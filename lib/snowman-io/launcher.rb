module SnowmanIO
  class Launcher
    include Celluloid

    def initialize(options)
      @options = options
    end

    def start
      app = Rack::Cascade.new [API::Root, Web]
      @web_server = WebServer.supervise_as(:web_server, app, @options.slice(:port, :host, :verbose))
      @ping = Loop::Ping.supervise_as(:ping)
      @main = Loop::Main.supervise_as(:main)
      @checks = Loop::Checks.supervise_as(:checks)
    end

    def stop
      @checks.terminate
      @main.terminate
      @ping.terminate
      @web_server.terminate # TODO: shutdown blocking?
    end
  end
end
