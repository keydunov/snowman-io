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
          if get(Storage::TODAY) != now.beginning_of_day.to_i
            set(Storage::TODAY, now.beginning_of_day.to_i)
            set(Storage::METRICS_TODAY_COUNT, 0)
          end
          incr(Storage::METRICS_TOTAL_COUNT)
          incr(Storage::METRICS_TODAY_COUNT)
        end
      end

      protected

      def _daily_metrics_for_app(app_id, at)
        json = {}
        today_key = at.beginning_of_day.to_i.to_s
        yesterday_key = (at - 1.day).beginning_of_day.to_i.to_s

        if m = metrics_raw_find_by_app_id_and_kind(app_id, "request", ["daily"])
          today =  m["daily"].try(:[], today_key)
          yesterday =  m["daily"].try(:[], yesterday_key)
          if today
            json["today"] = {
              "count" => today["count"],
              "duration" => Utils.human_value(today["90pct"])
            }
          end
          if yesterday
            json["yesterday"] = {
              "count" => yesterday["count"],
              "duration" => Utils.human_value(yesterday["90pct"])
            }
          end
        end

        json
      end
    end
  end
end
