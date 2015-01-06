module SnowmanIO
  module Loop
    class Aggregate
      include Celluloid

      def initialize
        schedule
        async.tick
      end

      def tick
        if Time.now > @aggregate_at
          clean(@aggregate_at - 1.day)
          process(@aggregate_at - 1.day)
          schedule
        end

        after(600) { tick }
      end

      private

      def schedule
        @aggregate_at = Time.now.end_of_day + 1.second
      end

      def clean(before)
        SnowmanIO.storage.metrics_clean(before)
      end

      def process(at)
        SnowmanIO.storage.metrics_all.each do |metric|
          SnowmanIO.storage.metrics_aggregate(metric["name"], at)
        end
      end
    end
  end
end
