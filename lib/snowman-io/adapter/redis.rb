require 'redis'

module SnowmanIO
  module Adapter
    class Redis < Base
      def initialize(url)
        @redis = ::Redis.new(url: url)
      end

      def kind
        :redis
      end

      # Sets value
      def set(key, value)
        @redis.set(key, [value].to_json)
      end

      # Gets value
      def get(key)
        if raw = @redis.get(key)
          JSON.parse(raw).first
        end
      end

      # Increases integer value by 1
      def incr(key)
        new_value = (get(key) || 0) + 1
        set(key, new_value)
        new_value
      end

      # Push value to array
      # FIXME: this impl is very slow
      def push(key, max_size, value)
        new_value = ((get(key) || []) + [value])
        if new_value.length > max_size
          new_value = new_value[-max_size..-1]
        end
        set(key, new_value)
      end

      # Remove key
      def unset(key)
        @redis.del(key)
      end

      # Returns all key by mask. The mask accepts '*' symbol for any amount of any symbols
      def keys(mask)
        @redis.keys(mask).sort
      end
    end
  end
end
