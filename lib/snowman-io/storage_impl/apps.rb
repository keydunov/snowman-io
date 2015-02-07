module SnowmanIO
  module StorageImpl
    module Apps
      def apps_all
        idfy SnowmanIO.mongo.db["apps"].find().to_a.tap { |apps|
          apps.each do |app|
            _app_wrap(app)
          end
        }
      end

      def apps_find(id)
        idfy SnowmanIO.mongo.db["apps"].find({_id: BSON::ObjectId(id)}).first.tap { |app|
          _app_wrap(app)
        }
      end

      def apps_find_by_token(token)
        idfy SnowmanIO.mongo.db["apps"].find({token: token}).first.tap { |app|
          if app
            _app_wrap(app)
          end
        }
      end

      def apps_create(options = {})
        idfy SnowmanIO.mongo.db["apps"].find_and_modify(
          query: options,
          upsert: true,
          new: true,
          update: options.merge("token" => SecureRandom.hex(20))
        )
      end

      def apps_update(id, options = {})
        idfy SnowmanIO.mongo.db["apps"].find_and_modify(
          query: {_id: BSON::ObjectId(id)},
          upsert: true,
          new: true,
          update: {"$set" => options}
        )
      end

      def apps_delete(id)
        SnowmanIO.mongo.db["apps"].remove({_id: BSON::ObjectId(id)})
        SnowmanIO.mongo.db["metrics"].remove({app_id: BSON::ObjectId(id)})
        {id: id}
      end

      private

      def _app_wrap(app)
        now = Time.now
        today_key = now.beginning_of_day.to_i.to_s
        yesterday_key = (now - 1.day).beginning_of_day.to_i.to_s
        json = {}
        if m = metrics_raw_find_by_app_id_and_kind(app["_id"].to_s, "request", ["daily"])
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
        app["requestsJSON"] = json.to_json
      end
    end
  end
end
