module SnowmanIO
  class Storage
    ADMIN_PASSWORD_KEY = "admin_password_hash"
    BASE_URL_KEY = "base_url"
    GLOBAL_ID_KEY = "global_id"


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

    def collectors_all()
      SnowmanIO.mongo.db["collectors"].find().sort(name: 1).to_a.map do |doc|
        doc.except("_id")
      end
    end

    def collectors_find(id)
      if doc = SnowmanIO.mongo.db["collectors"].find(id: id.to_i).first
        doc.except("_id")
      end
    end

    def collectors_create(attributes)
      collectors_update(incr(GLOBAL_ID_KEY), attributes)
    end

    def collectors_update(id, attributes)
      SnowmanIO.mongo.db["collectors"].find_and_modify({
        query: {id: id.to_i},
        upsert: true,
        update: attributes.merge(id: id.to_i),
        new: true
      }).except("_id")
    end

    def collectors_delete(id)
      SnowmanIO.mongo.db["collectors"].remove(id: id.to_i)
      {id: id.to_i}
    end

    def metrics_all(options = {})
      if options[:with_last_value]
        # get 2 last collections
        floor_key = Utils.date_to_key(Utils.floor_time(Time.now))
        values = SnowmanIO.mongo.db["5mins"].find({key: {"$lte" => floor_key}}).sort(key: :desc).to_a[0..1]
      end

      SnowmanIO.mongo.db["metrics"].find().sort(name: 1).to_a.map do |json|
        metric = json.except("_id")
        if options[:with_last_value]
          metric["lastValue"] =
            values[0].try(:[], metric["id"].to_s) ||
            values[1].try(:[], metric["id"].to_s)
        end
        metric
      end
    end

    def metrics_register_value(name, value, at)
      key = Utils.date_to_key(at)

      if metric = SnowmanIO.mongo.db["metrics"].find(name: name).first
        metric_id = metric["id"]
      else
        metric_id = incr("GLOBAL_ID_KEY")
        SnowmanIO.mongo.db["metrics"].insert(id: metric_id, name: name)
      end

      SnowmanIO.mongo.db["5mins"].update(
        {key: key},
        {"$set" => {key: key, metric_id.to_s => value}},
        upsert: true
      )
    end

    # Aggregate day metrics
    def metrics_aggregate(name, at)
      metric = SnowmanIO.mongo.db["metrics"].find(name: name).first
      return unless metric
      metric_id = metric["id"]
      from = at
      to = at + 1.day

      values = SnowmanIO.mongo.db["5mins"].find({
        key: {"$gte" => Utils.date_to_key(from), "$lt" => Utils.date_to_key(to)}
      }, fields: ["key", metric_id.to_s]).sort(key: :asc).to_a.map{ |v| v[metric_id.to_s] }.compact

      return if values.empty?
      max = values.max
      min = values.min
      avg = values.sum/values.length

      key = Utils.date_to_key(at)
      SnowmanIO.mongo.db["daily"].update(
        {key: key},
        {"$set" => {
          key: key,
          "#{metric_id}.max" => max,
          "#{metric_id}.min" => min,
          "#{metric_id}.avg" => avg
        }},
        upsert: true
      )
    end

    def metrics_clean(before)
      # TODO: keep only 1 year of daily metrics
      SnowmanIO.mongo.db["5mins"].remove({key: {"$lt" => Utils.date_to_key(before)}})
    end

    def metrics_daily(at)
      SnowmanIO.mongo.db["daily"].find({key: Utils.date_to_key(at)}).first
    end

    def reports_create(key, options)
      SnowmanIO.mongo.db["reports"].insert(options.merge(key: key))
      # keep last 7 reports
      keys = SnowmanIO.mongo.db["reports"].find({}, fields: ["key"]).sort(key: :desc).map { |x| x["key"] }
      if keys.length > 7
        SnowmanIO.mongo.db["reports"].remove({key: {"$in" => [keys[7..-1]]}})
      end
    end

    def reports_all()
      SnowmanIO.mongo.db["reports"].find().sort(key: :asc).to_a.map do |doc|
        doc.except("_id").merge("id" => doc["key"])
      end
    end

    def reports_find(key)
      if doc = SnowmanIO.mongo.db["reports"].find(key: key.to_i).first
        doc.except("_id").merge("id" => doc["key"])
      end
    end
  end
end
