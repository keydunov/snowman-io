module SnowmanIO
  class Launcher
    include Celluloid

    def initialize(options)
      @options = options
    end

    def start
      @web_server_supervisor = WebServer.supervise_as(:web_server, API, @options.slice(:port, :host, :verbose))
      @collect = Loop::Collect.new_link
      @collect.async.tick
    end

    def stop
      @collect.terminate
      @web_server_supervisor.terminate # TODO: shutdown blocking?
    end
  end
end
