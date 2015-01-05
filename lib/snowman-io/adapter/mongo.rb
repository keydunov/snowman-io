require "mongo"

module SnowmanIO
  module Adapter
    class Mongo
      def initialize(url)
        mongo_uri = ENV['MONGOLAB_URI']
        db_name = url[%r{/([^/\?]+)(\?|$)}, 1]
        client = ::Mongo::MongoClient.from_uri(url)
        db = client.db(db_name)
        @coll = db['SnowmanIO']
      end

      def kind
        :mongo
      end

      # Sets value
      def set(key, value)
        @coll.update({key: key}, {key: key, value: value}, upsert: true)
      end

      # Gets value
      def get(key)
        if doc = @coll.find({key: key}).first
          doc["value"]
        end
      end

      # Increases integer value by 1
      def incr(key)
        @coll.find_and_modify(
          query: {key: key},
          upsert: true,
          update: {"$inc" => {value: 1}},
          new: true
        )["value"]
      end

      # Push value to array
      def push(key, max_size, value)
        @coll.update(
          {key: key},
          {"$push" => {
            value: {
              "$each" => [value],
              "$slice" => -max_size
            }
          }},
          upsert: true
        )
      end

      # Remove key
      def unset(key)
        @coll.remove({key: key})
      end

      # Returns all key by mask. The mask accepts '*' symbol for any amount of any symbols
      def keys(mask)
        regex = "^" + mask.gsub("*", ".*") + "$"
        @coll.find({key: {"$regex" => regex}}).to_a.map{ |i| i["key"] }
      end
    end
  end
end
