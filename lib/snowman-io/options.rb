require 'optparse'

module SnowmanIO
  # Parse command line.
  class Options
    AVAILABLE_COMMANDS = %w[server]

    def parse!(args)
      options = default_options

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: snowman COMMAND [options]"

        opts.separator ""
        opts.separator "Commands"
        opts.separator "  server       Run SnowmanIO server"

        opts.separator ""
        opts.separator "Server options:"
        opts.on("-p", "--port PORT", "use PORT (default: 4567)") do |port|
          options[:port] = port.to_i
        end

        if args.empty?
          puts opts
          exit
        end

        options[:command] = args.shift
        unless AVAILABLE_COMMANDS.include?(options[:command])
          puts "Error: Command '#{options[:command]}' not recognized"
          puts opts
          exit
        end
      end

      opt_parser.parse!(args)
      options
    end

    private

    def default_options
      {
        port: 4567
      }
    end
  end
end
