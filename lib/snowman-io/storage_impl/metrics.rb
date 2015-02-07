module SnowmanIO
  module StorageImpl
    module Metrics
      def metrics_raw_find_by_app_id_and_kind(app_id, kind, fields = [])
        SnowmanIO.mongo.db["metrics"].find(
          {
            app_id: BSON::ObjectId(app_id),
            kind: kind
          },
          fields: fields
        ).first
      end

      def metrics_register_value(name, value, options = {})
        app = options[:app]
        at = options[:at] || Time.now

        attributes = {name: name}
        if app
          attributes[:app_id] = BSON::ObjectId(app["id"])
        end
        if options[:kind]
          attributes[:kind] = options[:kind]
        end

        SnowmanIO.mongo.db["metrics"].update(
          attributes,
          {
            "$set" => attributes.merge(last_value: value.to_f),
            "$push" => {"realtime.#{at.to_i}" => value}
          },
          upsert: true
        )

        if app
          now = Time.now
          if get(TODAY) != now.beginning_of_day.to_i
            set(TODAY, now.beginning_of_day.to_i)
            set(METRICS_TODAY_COUNT, 0)
          end
          incr(METRICS_TOTAL_COUNT)
          incr(METRICS_TODAY_COUNT)
        end
      end
    end
  end
end
