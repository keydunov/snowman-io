module SnowmanIO
  class Storage
    ADMIN_PASSWORD_KEY = "admin_password_hash"
    BASE_URL_KEY = "base_url"
    GLOBAL_ID_KEY = "global_id"
    NEXT_REPORT_FOR = "next_report_for"

    def set(key, value)
      SnowmanIO.mongo.db["system"].update({key: key}, {key: key, value: value}, upsert: true)
    end

    def get(key)
      SnowmanIO.mongo.db["system"].find({key: key}).first.try(:[], "value")
    end

    def metrics_all
      now = Time.now
      idfy(SnowmanIO.mongo.db["metrics"].find(
        {}, fields: ["name", "last_value", "5min"]
      ).sort(name: 1).to_a).tap { |metrics|
        metrics.each { |metric| _metric_wrap(metric, now) }
      }
    end

    def metrics_find(id)
      now = Time.now
      idfy SnowmanIO.mongo.db["metrics"].find(
        {_id: BSON::ObjectId(id)}, fields: ["name", "last_value", "5min"]
      ).first.tap { |metric| _metric_wrap(metric, now) }
    end

    def _metric_wrap(metric, now)
      from = Utils.floor_time(now) - 1.day + 5.minutes
      to = Utils.floor_time(now)
      from_key = Utils.date_to_key(from)
      to_key = Utils.date_to_key(to)

      points = 288.times.map { |i|
        {"at" => i, "value" => 0}
      }

      metric.delete("5min").each { |key, hash|
        if from_key <= key.to_i && key.to_i <= to_key
          points[(Utils.key_to_date(key.to_i).to_i - from.to_i)/300]["value"] = hash["med"]
        end
      }

      metric["points_5min_json"] = points.to_json
    end

    def metrics_register_value(name, value, at = Time.now)
      key = Utils.date_to_key(at)

      SnowmanIO.mongo.db["metrics"].update(
        {name: name},
        {
          "$set" => {"name" => name, "last_value" => value.to_f},
          "$push" => {"realtime.#{key}" => value.to_f}
        },
        upsert: true
      )
    end

    # Aggregate 5mins metrics
    def metrics_aggregate_5min
      key_to_keep = Utils.date_to_key(Utils.floor_time(Time.now - 1.minute))

      SnowmanIO.mongo.db["metrics"].find({}, fields: ["realtime"]).each do |metric|
        metric["realtime"].each do |key, values|
          # aggregate & store
          SnowmanIO.mongo.db["metrics"].update(
            {"_id" => metric["_id"]},
            {"$set" => {
              "5min.#{key}.count" => values.length,
              "5min.#{key}.min" => values.min,
              "5min.#{key}.perc10" => Utils.perc(values, 0.1),
              "5min.#{key}.avg" => Utils.avg(values),
              "5min.#{key}.med" => Utils.med(values),
              "5min.#{key}.perc90" => Utils.perc(values, 0.9),
              "5min.#{key}.max" => values.max,
              "5min.#{key}.sum" => values.inject(&:+)
            }}
          )

          # clean old realtime records
          if key.to_i < key_to_keep
            SnowmanIO.mongo.db["metrics"].update(
              {"_id" => metric["_id"]},
              {"$unset" => {"realtime.#{key}" => ""}}
            )
          end
        end
      end
    end

    # Aggregate daily metrics
    def metrics_aggregate_daily
      key_to_keep = (Utils.date_to_key(Utils.floor_time(Time.now - 1.day - 1.hour))/1000)*1000

      SnowmanIO.mongo.db["metrics"].find({}, fields: ["5min"]).each do |metric|
        next if metric["5min"].empty?

        out = {}

        # accumulate
        metric["5min"].each do |key, chunk|
          dk = (key.to_i/1000)*1000
          out[dk] ||= {"count" => 0, "perc10" => 0, "avg" => 0, "med" => 0, "perc90" => 0, "sum" => 0}
          out[dk]["count"] += chunk["count"]
          out[dk]["min"] = chunk["min"] if !out[dk]["min"] || out[dk]["min"] > chunk["min"]
          out[dk]["perc10"] += chunk["perc10"]*chunk["count"]
          out[dk]["avg"] += chunk["avg"]*chunk["count"]
          out[dk]["med"] += chunk["med"]*chunk["count"]
          out[dk]["perc90"] += chunk["perc90"]*chunk["count"]
          out[dk]["max"] = chunk["max"] if !out[dk]["max"] || out[dk]["max"] < chunk["max"]
          out[dk]["sum"] += chunk["sum"]
        end

        # normalize
        out.each do |dk, chunk|
          chunk["perc10"] /= chunk["count"]
          chunk["avg"] /= chunk["count"]
          chunk["med"] /= chunk["count"]
          chunk["perc90"] /= chunk["count"]
        end

        # transform
        daily = {}
        out.each do |dk, chunk|
          daily["daily.#{dk}.count"] = chunk["count"]
          daily["daily.#{dk}.min"] = chunk["min"]
          daily["daily.#{dk}.perc10"] = chunk["perc10"]
          daily["daily.#{dk}.avg"] = chunk["avg"]
          daily["daily.#{dk}.med"] = chunk["med"]
          daily["daily.#{dk}.perc90"] = chunk["perc90"]
          daily["daily.#{dk}.max"] = chunk["max"]
          daily["daily.#{dk}.sum"] = chunk["sum"]
        end

        # store
        SnowmanIO.mongo.db["metrics"].update(
          {"_id" => metric["_id"]},
          {"$set" => daily}
        )

        # clean old 5min records
        metric["5min"].each do |key, chunk|
          if key.to_i < key_to_keep
            SnowmanIO.mongo.db["metrics"].update(
              {"_id" => metric["_id"]},
              {"$unset" => {"5min.#{key}" => ""}}
            )
          end
        end
      end
    end

    # Clean old daily records
    def metrics_clean_old_daily
      key_to_keep = (Utils.date_to_key(Utils.floor_time(Time.now - 365.days))/1000)*1000

      SnowmanIO.mongo.db["metrics"].find({}, fields: ["daily"]).each do |metric|
        metric["daily"].each do |key, chunk|
          if key.to_i < key_to_keep
            SnowmanIO.mongo.db["metrics"].update(
              {"_id" => metric["_id"]},
              {"$unset" => {"daily.#{key}" => ""}}
            )
          end
        end
      end
    end

    def reports_generate_once(report_for)
      key = Utils.date_to_key(report_for)
      return if reports_find_by_key(key)

      # compile
      report = []
      SnowmanIO.mongo.db["metrics"].find({}, fields: ["name", "daily.#{key}"]).each do |metric|
        daily = (metric["daily"] || {})[key.to_s] || {}
        report.push(
          "name" => metric["name"],
          "min" => daily["min"],
          "avg" => daily["avg"],
          "max" => daily["max"],
          "count" => daily["count"]
        )
      end

      # store
      if report.present?
        SnowmanIO.mongo.db["reports"].update(
          {key: key},
          {key: key, sended: false, report: JSON.dump(report)},
          upsert: true
        )
      end

      # clean
      key_to_keep = Utils.date_to_key(report_for - 7.days)
      SnowmanIO.mongo.db["reports"].remove({key: {"$lt" => key_to_keep}})
    end

    def reports_send_once(report_for)
      key = Utils.date_to_key(report_for)
      report = reports_find_by_key(key)
      return if !report || report["sended"]
      ReportMailer.daily_report(report_for, JSON.load(report["report"])).deliver
      SnowmanIO.mongo.db["reports"].update(
        {key: key},
        {"$set" => {"sended" => true}}
      )
    end

    def reports_all
      idfy SnowmanIO.mongo.db["reports"].find().sort(key: 1).to_a
    end

    def reports_find(id)
      idfy SnowmanIO.mongo.db["reports"].find({_id: BSON::ObjectId(id)}).first
    end

    def reports_find_by_key(key)
      idfy SnowmanIO.mongo.db["reports"].find({key: key}).first
    end

    private

    # Mongo ObjectId => String ID
    def idfy(obj)
      if obj
        obj.is_a?(Array) ? obj.map { |o| idfy(o) } : obj.merge("id" => obj.delete("_id").to_s)
      end
    end
  end
end
