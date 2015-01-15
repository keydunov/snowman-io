module SnowmanIO
  module Loop
    class Aggregate
      include Celluloid

      def initialize(start_immediately = true)
        schedule
        if start_immediately
          async.tick
        end
      end

      def tick
        if Time.now > @aggregate_at
          process(@aggregate_at)
          schedule
        end

        after(600) { tick }
      end

      protected

      def schedule
        @aggregate_at = Time.now.end_of_day + 1.second
        SnowmanIO.logger.debug "Next aggregation sheduled at: #{@aggregate_at}"
      end

      def process(at)
        SnowmanIO.storage.metrics_aggregate(at)
      end
    end
  end
end
