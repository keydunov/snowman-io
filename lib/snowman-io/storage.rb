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

    def metrics_register_value(name, value, at = Time.now)
      SnowmanIO.mongo.db["metrics"].update(
        {name: name},
        {
          "$set" => {"name" => name, "last_value" => value.to_f},
          "$push" => {"realtime.#{at.to_i}" => value}
        },
        upsert: true
      )
    end

    def metrics_aggregate_20sec
      SnowmanIO.mongo.db["metrics"].find({}, fields: ["realtime"]).each do |metric|
        aggr = {}

        # collect
        metric["realtime"].each do |at, values|
          key = Utils.floor_20sec(Time.at(at.to_i)).to_i
          aggr[key] ||= []
          aggr[key] += values
        end

        # aggregrate
        aggr.each do |key, values|
          SnowmanIO.mongo.db["metrics"].update(
            {"_id" => metric["_id"]},
            {"$set" => {
              "20sec.#{key}.count" => values.length,
              "20sec.#{key}.min" => values.min,
              "20sec.#{key}.avg" => Utils.avg(values),
              "20sec.#{key}.90pct" => Utils.pct(values, 0.9),
              "20sec.#{key}.max" => values.max,
              "20sec.#{key}.sum" => values.inject(&:+)
            }}
          )
        end
      end
    end

    # Aggregate 5mins metrics
    def metrics_aggregate_5min
      SnowmanIO.mongo.db["metrics"].find({}, fields: ["realtime"]).each do |metric|
        aggr = {}

        # collect
        metric["realtime"].each do |at, values|
          key = Utils.floor_5min(Time.at(at.to_i)).to_i
          aggr[key] ||= []
          aggr[key] += values
        end

        # aggregrate
        aggr.each do |key, values|
          SnowmanIO.mongo.db["metrics"].update(
            {"_id" => metric["_id"]},
            {"$set" => {
              "5min.#{key}.count" => values.length,
              "5min.#{key}.min" => values.min,
              "5min.#{key}.avg" => Utils.avg(values),
              "5min.#{key}.90pct" => Utils.pct(values, 0.9),
              "5min.#{key}.max" => values.max,
              "5min.#{key}.sum" => values.inject(&:+)
            }}
          )
        end
      end
    end

    # Aggregate daily metrics
    def metrics_aggregate_daily
      SnowmanIO.mongo.db["metrics"].find({}, fields: ["5min"]).each do |metric|
        next if metric["5min"].empty?

        out = {}

        # accumulate
        metric["5min"].each do |at, chunk|
          key = Time.at(at.to_i).beginning_of_day.to_i
          out[key] ||= {"count" => 0, "avg" => 0, "90pct" => 0, "sum" => 0}
          out[key]["count"] += chunk["count"]
          out[key]["min"] = chunk["min"] if !out[key]["min"] || out[key]["min"] > chunk["min"]
          out[key]["avg"] += chunk["avg"]*chunk["count"]
          out[key]["90pct"] += chunk["90pct"]*chunk["count"]
          out[key]["max"] = chunk["max"] if !out[key]["max"] || out[key]["max"] < chunk["max"]
          out[key]["sum"] += chunk["sum"]
        end

        # normalize
        out.each do |__, chunk|
          chunk["avg"] /= chunk["count"]
          chunk["90pct"] /= chunk["count"]
        end

        # transform
        daily = {}
        out.each do |key, chunk|
          daily["daily.#{key}.count"] = chunk["count"]
          daily["daily.#{key}.min"] = chunk["min"]
          daily["daily.#{key}.avg"] = chunk["avg"]
          daily["daily.#{key}.90pct"] = chunk["90pct"]
          daily["daily.#{key}.max"] = chunk["max"]
          daily["daily.#{key}.sum"] = chunk["sum"]
        end

        # store
        SnowmanIO.mongo.db["metrics"].update(
          {"_id" => metric["_id"]},
          {"$set" => daily}
        )
      end
    end

    # Clean old records
    def metrics_clean_old
      now = Time.now

      # clear realtime
      key_to_keep = Utils.floor_5min(now - 1.minutes).to_i
      SnowmanIO.mongo.db["metrics"].find({}, fields: ["realtime"]).each do |metric|
        unset = {}
        metric["realtime"].each do |key, __|
          if key.to_i < key_to_keep
            unset = {"realtime.#{key}" => ""}
          end
        end
        if unset.present?
          SnowmanIO.mongo.db["metrics"].update(
            {"_id" => metric["_id"]},
            {"$unset" => unset}
          )
        end
      end

      # clear 20 sec
      key_to_keep = Utils.floor_20sec(now - 14.minutes).to_i
      SnowmanIO.mongo.db["metrics"].find({}, fields: ["20sec"]).each do |metric|
        unset = {}
        metric["20sec"].each do |key, __|
          if key.to_i < key_to_keep
            unset = {"20sec.#{key}" => ""}
          end
        end
        if unset.present?
          SnowmanIO.mongo.db["metrics"].update(
            {"_id" => metric["_id"]},
            {"$unset" => unset}
          )
        end
      end

      # clear 5 min
      key_to_keep = (now - 1.hour).beginning_of_day.to_i
      SnowmanIO.mongo.db["metrics"].find({}, fields: ["5min"]).each do |metric|
        unset = {}
        metric["5min"].each do |key, __|
          if key.to_i < key_to_keep
            unset = {"5min.#{key}" => ""}
          end
        end
        if unset.present?
          SnowmanIO.mongo.db["metrics"].update(
            {"_id" => metric["_id"]},
            {"$unset" => unset}
          )
        end
      end

      # clear daily
      key_to_keep = (now - 365.days).beginning_of_day.to_i
      SnowmanIO.mongo.db["metrics"].find({}, fields: ["daily"]).each do |metric|
        unset = {}
        metric["daily"].each do |key, __|
          if key.to_i < key_to_keep
            unset = {"daily.#{key}" => ""}
          end
        end
        if unset.present?
          SnowmanIO.mongo.db["metrics"].update(
            {"_id" => metric["_id"]},
            {"$unset" => unset}
          )
        end
      end
    end

    def reports_generate_once(report_for)
      key = report_for.to_i
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
      key_to_keep = (report_for - 7.days).to_i
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

    def _metric_wrap(metric, now)
      # from = Utils.floor_time(now) - 1.day + 5.minutes
      # to = Utils.floor_time(now)
      # from_key = Utils.date_to_key(from)
      # to_key = Utils.date_to_key(to)
      #
      # points = 288.times.map { |i|
      #   {"at" => i, "value" => 0}
      # }
      #
      # metric.delete("5min").each { |key, hash|
      #   if from_key <= key.to_i && key.to_i <= to_key
      #     points[(Utils.key_to_date(key.to_i).to_i - from.to_i)/300]["value"] = hash["med"]
      #   end
      # }
      #
      # metric["points_5min_json"] = points.to_json
    end


    # Mongo ObjectId => String ID
    def idfy(obj)
      if obj
        obj.is_a?(Array) ? obj.map { |o| idfy(o) } : obj.merge("id" => obj.delete("_id").to_s)
      end
    end
  end
end
