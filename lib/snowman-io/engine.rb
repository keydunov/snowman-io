module SnowmanIO
  class Engine
    include Celluloid
    include Collectors::HostedGraphite

    def initialize
      @run_collectors_at = Utils.ceil_time(Time.now)
    end

    def tick
      if Time.now >= @run_collectors_at
        SnowmanIO.logger.info "Start collectors processing ..."
        run_collectors(@run_collectors_at)
        @run_collectors_at = Utils.ceil_time(Time.now)
        SnowmanIO.logger.info "Start collectors processing ... DONE"
      end

      after(1) { tick }
    end

    private

    def run_collectors(at)
      SnowmanIO.storage.collectors_all.each do |collector|
        run_collector(collector, at)
      end
    end

    def run_collector(collector, at)
      if collector["kind"] == "HG"
        SnowmanIO.storage.metrics_register_value(collector["hgMetric"], get_hg_value(collector["hgMetric"]), at)
      else
        raise "I dont know how collect #{collector.inspect}"
      end
    end
  end
end
