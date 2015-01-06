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
    end

    def stop
      @ping.terminate
      @collect.terminate
      @web_server_supervisor.terminate # TODO: shutdown blocking?
    end
  end
end
