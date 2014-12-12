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
      options[:checks] = load_checks

      # Self-pipe for deferred signal-handling (http://cr.yp.to/docs/selfpipe.html)
      self_read, self_write = IO.pipe

      %w(INT TERM USR1 USR2 TTIN).each do |sig|
        begin
          trap sig do
            self_write.puts(sig)
          end
        rescue ArgumentError
          puts "Signal #{sig} not supported"
        end
      end

      launcher = Launcher.new(options)

      begin
        launcher.start
        while readable_io = IO.select([self_read])
          signal = readable_io.first[0].gets.strip
          handle_signal(signal)
        end
      rescue Interrupt
        SnowmanIO.logger.info 'Shutting down'
        launcher.stop
        exit(0)
      end
    end

    private

    def handle_signal(sig)
      SnowmanIO.logger.debug "Received #{sig} signal"
      case sig
      when 'TERM'
        raise Interrupt
      when 'INT'
        raise Interrupt
      end
    end

    def setup_logger
      Celluloid.logger = (options[:verbose] ? SnowmanIO.logger : nil)
      if options[:verbose]
        SnowmanIO.logger.level = ::Logger::DEBUG
      else
        SnowmanIO.logger.level = ::Logger::INFO
      end
    end

    def load_checks
      Dir[Dir.pwd + '/**/*_check.rb'].map do |path|
        require path
        klass = path.sub(Dir.pwd + '/checks/', '').sub(/\.rb$/, '').camelize
        SnowmanIO.logger.debug("Load check #{klass}")
        Kernel.const_get(klass)
      end
    end
  end
end
