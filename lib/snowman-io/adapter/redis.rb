require 'redis'

module SnowmanIO
  module Adapter
    class Redis < Base
      def initialize(url)
        @redis = ::Redis.new(url: url)
      end

      # Sets string value
      def set(key, value)
        @redis.set(key, value)
      end

      # Gets string value
      def get(key)
        @redis.get(key)
      end


      # Sets integer value
      def seti(key, value)
        @redis.set(key, value)
      end

      # Increases integer value by 1
      def incr(key)
        @redis.incr(key)
      end

      # Gets integer value
      def geti(key)
        @redis.get(key).to_i
      end


      # Push value to array
      def push(key, value)
        @redis.lpush(key, value)
      end

      # Returns array length
      def len(key)
        @redis.llen(key)
      end

      # Shifts first array item
      def shift(key)
        @redis.rpop(key)
      end

      # Returns array
      def geta(key)
        @redis.lrange(key, 0, -1)
      end


      # Returns all key by mask. The mask accepts '*' symbol for any amount of any symbols
      def keys(mask)
        @redis.keys(mask)
      end
    end
  end
end
