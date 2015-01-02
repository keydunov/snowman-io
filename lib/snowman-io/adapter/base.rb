module SnowmanIO
  module Adapter
    class Base
      def kind
        raise "implemenent this method in concrete adapter"
      end

      # Sets value
      def set(key, value)
        raise "implemenent this method in concrete adapter"
      end

      # Gets value
      def get(key)
        raise "implemenent this method in concrete adapter"
      end

      # Increases integer value by 1
      def incr(key)
        raise "implemenent this method in concrete adapter"
      end

      # Push value to array
      def push(key, max_size, value)
        raise "implemenent this method in concrete adapter"
      end

      # Returns all key by mask. The mask accepts '*' symbol for any amount of any symbols
      def keys(mask)
        raise "implemenent this method in concrete adapter"
      end
    end
  end
end
