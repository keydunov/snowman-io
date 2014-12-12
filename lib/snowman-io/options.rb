require 'optparse'

module SnowmanIO
  # Parse command line.
  class Options
    def parse!(args)
      options = default_options

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: snowman [options]"

        opts.separator ""
        opts.separator "Options:"
        opts.on("-p", "--port PORT", "use PORT (default: 4567)") do |port|
          options[:port] = port.to_i
        end

        opts.on "-v", "--verbose", "print more verbose output" do |arg|
          options[:verbose] = arg
        end

        opts.on '-t', '--timeout NUM', "shutdown timeout" do |arg|
          options[:timeout] = Integer(arg)
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
        :port    => 4567,
        :timeout => 8,
        :host    => "0.0.0.0"
      }
    end
  end
end
