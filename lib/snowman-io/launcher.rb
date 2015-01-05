module SnowmanIO
  class Launcher
    include Celluloid

    def initialize(options)
      @options = options
    end

    def start
      @web_server_supervisor = WebServer.supervise_as(:web_server, API, @options.slice(:port, :host, :verbose))
      @engine = Engine.new_link
      @engine.async.tick
    end

    def stop
      @engine.terminate
      @web_server_supervisor.terminate # TODO: shutdown blocking?
    end
  end
end
