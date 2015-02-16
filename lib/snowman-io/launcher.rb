module SnowmanIO
  class Launcher
    include Celluloid

    def initialize(options)
      @options = options
    end

    def start
      @web_server = WebServer.supervise_as(:web_server, API, @options.slice(:port, :host, :verbose))
      @ping = Loop::Ping.supervise_as(:ping)
      @main = Loop::Main.supervise_as(:main)
    end

    def stop
      @main.terminate
      @ping.terminate
      @web_server.terminate # TODO: shutdown blocking?
    end
  end
end
