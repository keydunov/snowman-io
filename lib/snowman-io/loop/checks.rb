module SnowmanIO
  module Loop
    class Checks
      include Celluloid

      def initialize
        after(1) { tick }
      end

      def tick
        perform
        after(3) { tick }
      end

      private

      def perform
        Check.all.each do |check|
          puts "TODO: process: #{check.inspect}"
        end
      end
    end
  end
end
