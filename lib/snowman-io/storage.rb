module SnowmanIO
  class Storage
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
        # get time period which exactly calculated
        floor_key = Utils.date_to_key(Utils.floor_time(Time.now))
        values = SnowmanIO.mongo.db["5mins"].find({key: {"$lt" => floor_key}}).sort(key: :desc).first
      end

      SnowmanIO.mongo.db["metrics"].find().sort(name: 1).to_a.map do |json|
        metric = json.except("_id")
        if options[:with_last_value]
          metric["lastValue"] = values[metric["id"].to_s]
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
  end
end
