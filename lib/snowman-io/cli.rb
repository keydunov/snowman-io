module SnowmanIO
  # The command line interface for SnowmanIO.
  class CLI
    attr_reader :options

    def self.run
      options = Options.new.parse!(ARGV)
      new(options).run
    end

    def initialize(options = {})
      @options = options
    end

    def run
      setup_logger
      setup_signal_traps

      launcher = Launcher.new(load_checks)
      launcher.start

      # start web server on main thread
      API.start(options)
    end

    private

    def setup_logger
      Celluloid.logger = (options[:verbose] ? SnowmanIO.logger : nil)
      if options[:verbose]
        SnowmanIO.logger.level = ::Logger::DEBUG
      else
        SnowmanIO.logger.level = ::Logger::INFO
      end
    end

    def setup_signal_traps
      %w(INT TERM).each { |sig| trap(sig) { stop } }
    end

    def stop
      # TODO: graceful shutdown
    end

    def load_checks
      Dir[Dir.pwd + '/**/*_check.rb'].map do |path|
        require path
        klass = path.sub(Dir.pwd + '/checks/', '').sub(/\.rb$/, '').camelize
        Kernel.const_get(klass)
      end
    end
  end
end
