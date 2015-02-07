module SnowmanIO
  module StorageImpl
    module System
      def set(key, value)
        SnowmanIO.mongo.db["system"].update({key: key}, {key: key, value: value}, upsert: true)
      end

      def get(key)
        SnowmanIO.mongo.db["system"].find({key: key}).first.try(:[], "value")
      end

      def incr(key)
        SnowmanIO.mongo.db["system"].find_and_modify(
          query: {key: key},
          upsert: true,
          new: true,
          update: {"$inc" => {value: 1}}
        )["value"]
      end
    end
  end 
end
