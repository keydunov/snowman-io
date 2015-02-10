module SnowmanIO
  class Launcher
    include Celluloid

    def initialize(options)
      @options = options
    end

    def start
      @web_server_supervisor = WebServer.supervise_as(:web_server, API, @options.slice(:port, :host, :verbose))

      # self ping to be in fit
      @ping = Loop::Ping.supervise_as(:ping)
      @main = Loop::Main.supervise_as(:main)
    end

    def stop
      @main.terminate
      @ping.terminate
      @web_server_supervisor.terminate # TODO: shutdown blocking?
    end
  end
end
