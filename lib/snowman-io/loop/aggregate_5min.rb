module SnowmanIO
  module Loop
    class Aggregate5Min
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

        after(5) { tick }
      end

      protected

      def schedule
        @aggregate_at = Utils::ceil_time(Time.now)
        SnowmanIO.logger.debug "Next 5min aggregation sheduled at: #{@aggregate_at}"
      end

      def process(at)
        SnowmanIO.storage.metrics_aggregate_5mins(at)
      end
    end
  end
end
