module SnowmanIO
  module Adapter
    class Base
      def kind
        raise "implemenent this method in concrete adapter"
      end

      # Sets string value
      def set(key, value)
        raise "implemenent this method in concrete adapter"
      end

      # Gets string value
      def get(key)
        raise "implemenent this method in concrete adapter"
      end


      # Sets integer value
      def seti(key, value)
        raise "implemenent this method in concrete adapter"
      end

      # Increases integer value by 1
      def incr(key)
        raise "implemenent this method in concrete adapter"
      end

      # Gets integer value
      def geti(key)
        raise "implemenent this method in concrete adapter"
      end


      # Push value to array
      def push(key, value)
        raise "implemenent this method in concrete adapter"
      end

      # Returns array length
      def len(key)
        raise "implemenent this method in concrete adapter"
      end

      # Shifts first array item
      def shift(key)
        raise "implemenent this method in concrete adapter"
      end

      # Returns array
      def geta(key)
        raise "implemenent this method in concrete adapter"
      end


      # Returns all key by mask. The mask accepts '*' symbol for any amount of any symbols
      def keys(mask)
        raise "implemenent this method in concrete adapter"
      end
    end
  end
end
