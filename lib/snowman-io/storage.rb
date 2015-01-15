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
      if doc = SnowmanIO.mongo.db["system"].find({key: key}).first
        doc["value"]
      end
    end

    def incr(key)
      SnowmanIO.mongo.db["system"].find_and_modify(
        query: {key: key},
        upsert: true,
        update: {"$inc" => {value: 1}},
        new: true
      )["value"]
    end

    def metrics_all(options = {})
      SnowmanIO.mongo.db["metrics"].find({}, fields: ["id", "name", "last_value"]).sort(name: 1).to_a
    end

    def metrics_find(id)
      SnowmanIO.mongo.db["metrics"].find({id: id.to_i}, fields: ["id", "name", "last_value"]).first
    end

    def metrics_find_or_create(name)
      if metric = SnowmanIO.mongo.db["metrics"].find(name: name).first
        metric
      else
        metric_id = incr(GLOBAL_ID_KEY)
        SnowmanIO.mongo.db["metrics"].find_and_modify(
          query: {id: metric_id},
          upsert: true,
          new: true,
          update: {id: metric_id, name: name}
        )
      end
    end

    def metrics_register_value(name, value, at = Time.now)
      key = Utils.date_to_key(at)
      metric = Celluloid::Actor[:metric_registry].get_metric(name)

      SnowmanIO.mongo.db["metrics"].update(
        {id: metric["id"]},
        {
          "$set" => {"last_value" => value},
          "$push" => {"rt.#{key}" => {"$each" => [value]}}
        }
      )
    end

    # Aggregate 5mins metrics
    def metrics_aggregate_5mins(at)
      key = Utils.key_to_date(at)
      SnowmanIO.mongo.db["metrics"].find().each do |metric|
        metric["rt"].each do |k, values|
          if k.to_i < key && values.present?
            max = values.max
            min = values.min
            avg = values.sum/values.length
            count = values.length

            SnowmanIO.mongo.db["5mins"].update(
              {key: k.to_i},
              {"$set" => {
                key: k.to_i,
                "#{metric["id"]}.max" => max,
                "#{metric["id"]}.min" => min,
                "#{metric["id"]}.avg" => avg,
                "#{metric["id"]}.count" => count
              }},
              upsert: true
            )

            SnowmanIO.mongo.db["metrics"].update(
              {id: metric["id"]},
              {"$unset" => {"rt.#{k}" => ""}}
            )
          end
        end
      end
    end

    # Aggregate day metrics
    def metrics_aggregate(at)
      from = at - 1.day
      to = at

      SnowmanIO.mongo.db["metrics"].find({}, fields: ["id"]).each do |metric|
        values = SnowmanIO.mongo.db["5mins"].find({
            key: {"$gte" => Utils.date_to_key(from), "$lt" => Utils.date_to_key(to)}
          }, fields: ["key", metric["id"].to_s]
        ).sort(key: :asc).to_a.map{ |v| v[metric["id"].to_s] }.compact

        next if values.empty?

        key = Utils.date_to_key(from)
        max = values.map{ |v| v["max"] }.max
        min = values.map{ |v| v["min"] }.min
        count = values.map{ |v| v["count"] }.inject(&:+)
        avg = values.map{ |v| v["avg"]*v["count"]/count }.inject(&:+)

        SnowmanIO.mongo.db["daily"].update(
          {key: key},
          {"$set" => {
            key: key,
            "#{metric["id"]}.max" => max,
            "#{metric["id"]}.min" => min,
            "#{metric["id"]}.avg" => avg,
            "#{metric["id"]}.count" => count
          }},
          upsert: true
        )
      end

      SnowmanIO.mongo.db["5mins"].remove({
        key: {"$gte" => Utils.date_to_key(from), "$lt" => Utils.date_to_key(to)}
      })
    end

    def metrics_daily(at)
      SnowmanIO.mongo.db["daily"].find({key: Utils.date_to_key(at)}).first
    end

    def reports_create(key, options)
      SnowmanIO.mongo.db["reports"].update(
        {key: key},
        options.merge(key: key),
        upsert: true
      )
      # keep last 7 reports
      keys = SnowmanIO.mongo.db["reports"].find({}, fields: ["key"]).sort(key: :desc).map { |r| r["key"] }
      if keys.length > 7
        SnowmanIO.mongo.db["reports"].remove({key: {"$in" => [keys[7..-1]]}})
      end
    end

    def reports_all()
      SnowmanIO.mongo.db["reports"].find().sort(key: :asc).to_a.map do |doc|
        doc.except("_id").merge("id" => doc["key"]).tap { |doc|
          doc["rawReport"] = JSON.dump(doc.delete("report"))
        }
      end
    end

    def reports_find(key)
      if doc = SnowmanIO.mongo.db["reports"].find(key: key.to_i).first
        doc.except("_id").merge("id" => doc["key"]).tap { |doc|
          doc["rawReport"] = JSON.dump(doc.delete("report"))
        }
      end
    end
  end
end
