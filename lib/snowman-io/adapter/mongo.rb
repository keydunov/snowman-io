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

      # Sets string value
      def set(key, value)
        @coll.update({key: key}, {key: key, value: value}, upsert: true)
      end

      # Gets string value
      def get(key)
        if doc = @coll.find({key: key}).first
          doc["value"]
        end
      end


      # Sets integer value
      def seti(key, value)
        set(key, value)
      end

      # Increases integer value by 1
      def incr(key)
        @coll.find_and_modify(query: {key: key}, upsert: true, update: {"$inc" => {value: 1}}, new: true)["value"]
      end

      # Gets integer value
      def geti(key)
        get(key)
      end


      # Push value to array
      def push(key, value)
        @coll.update({key: key}, {"$push" => {value: value}}, upsert: true)
        # raise "implemenent this method in concrete adapter"
      end

      # Returns array length
      def len(key)
        get(key).length
      end

      # Shifts first array item
      def shift(key)
        @coll.find_and_modify(query: {key: key}, update: {"$pop" => {value: -1}})["value"].first
      end

      # Returns array
      def geta(key)
        get(key)
      end


      # Returns all key by mask. The mask accepts '*' symbol for any amount of any symbols
      def keys(mask)
        regex = "^" + mask.gsub("*", ".*") + "$"
        @coll.find({key: {"$regex" => regex}}).to_a.map{ |i| i["key"] }
      end
    end
  end
end
