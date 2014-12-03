require 'optparse'

module SnowmanIO
  # Parse command line.
  class Options
    AVAILABLE_COMMANDS = %w[server]

    def parse!(args)
      options = default_options

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: snowman [options]"

        opts.separator ""
        opts.separator "Options:"
        opts.on("-p", "--port PORT", "use PORT (default: 4567)") do |port|
          options[:port] = port.to_i
        end

        opts.on("-h", "--help", "show this message") do
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
