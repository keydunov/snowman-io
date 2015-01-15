module SnowmanIO
  class Launcher
    include Celluloid

    def initialize(options)
      @options = options
    end

    def start
      @web_server_supervisor = WebServer.supervise_as(:web_server, API, @options.slice(:port, :host, :verbose))
      @metric_registry = MetricRegistry.supervise_as(:metric_registry)
      @ping = Loop::Ping.supervise_as(:ping_loop)
      @aggregate_5min = Loop::Aggregate5Min.supervise_as(:aggregate_5min_loop)
      @aggregate = Loop::Aggregate.supervise_as(:aggregate_loop)
      @report = Loop::Report.supervise_as(:report_loop)
    end

    def stop
      @report.terminate
      @aggregate.terminate
      @aggregate_5min.terminate
      @ping.terminate
      @metric_registry.terminate
      @web_server_supervisor.terminate # TODO: shutdown blocking?
    end
  end
end
