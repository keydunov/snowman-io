module SnowmanIO
  class Launcher
    include Celluloid

    def initialize(options)
      @options = options
    end

    def start
      @web_server_supervisor = WebServer.supervise_as(:web_server, API, @options.slice(:port, :host, :verbose))
      @collect = Loop::Collect.supervise_as(:collect_loop)
      @ping = Loop::Ping.supervise_as(:ping_loop)
      @aggregate = Loop::Aggregate.supervise_as(:aggregate_loop)
    end

    def stop
      @aggregate.terminate
      @ping.terminate
      @collect.terminate
      @web_server_supervisor.terminate # TODO: shutdown blocking?
    end
  end
end
