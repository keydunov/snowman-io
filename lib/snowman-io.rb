require "snowman-io/version"
require "snowman-io/api"
require "snowman-io/options"

module SnowmanIO
  def self.start
    # parse options
    options = Options.new.parse!(ARGV)

    case options[:command]
    when "server"
      API.start(options)
    else
      abort "Unreacheable point. Please report the bug to https://github.com/snowman-io/snowman-io/issues"
    end
  end
end
