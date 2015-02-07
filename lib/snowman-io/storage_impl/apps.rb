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
        app["requestsJSON"] = _daily_metrics_for_app(app["_id"].to_s, Time.now).to_json
      end
    end
  end
end
