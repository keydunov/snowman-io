module SnowmanIO
  module Loop
    class Collect
      include Celluloid

      def initialize
        @run_at = Utils.ceil_time(Time.now)
        @pool = CollectWorker.pool(size: 10)
        async.tick
      end

      def tick
        if Time.now >= @run_at
          process
          @run_at = Utils.ceil_time(Time.now)
        end

        after(1) { tick }
      end

      private

      def process
        SnowmanIO.logger.info "Start collectors processing ..."

        SnowmanIO.storage.collectors_all.map { |collector|
          @pool.future.collect(collector, @run_at)
        }.map(&:value)

        SnowmanIO.logger.info "Start collectors processing ... DONE"
      end
    end
  end
end
