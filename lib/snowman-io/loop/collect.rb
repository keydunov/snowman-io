module SnowmanIO
  module Loop
    class Collect
      include Celluloid

      def initialize(start_immediately = true)
        @run_at = Utils.ceil_time(Time.now)
        @pool = CollectWorker.pool(size: 10)

        if start_immediately
          async.tick
        end
      end

      def tick
        if Time.now >= @run_at
          process(@run_at)
          @run_at = Utils.ceil_time(Time.now)
        end

        after(1) { tick }
      end

      protected

      def process(at)
        SnowmanIO.logger.info "Start collectors processing ..."

        SnowmanIO.storage.collectors_all.map { |collector|
          @pool.future.collect(collector, at)
        }.map(&:value)

        SnowmanIO.logger.info "Start collectors processing ... DONE"
      end
    end
  end
end
