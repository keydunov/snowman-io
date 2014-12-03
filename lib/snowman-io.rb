require 'logger'
require 'redis'
require 'bcrypt'
require 'celluloid/autostart'

require "snowman-io/version"
require "snowman-io/api"
require "snowman-io/options"
require "snowman-io/checks/hosted_graphite"
require "snowman-io/check"
require "snowman-io/check_result"

require "snowman-io/launcher"

module SnowmanIO
  def self.start
    # parse options
    options = Options.new.parse!(ARGV)

    Celluloid.logger = (options[:verbose] ? SnowmanIO.logger : nil)

    launcher = Launcher.new(load_checks)
    launcher.start

    # start web server on main thread
    API.start(options)
  end

  def self.load_checks
    checks = []
    Dir[Dir.pwd + "/**/*_check.rb"].each do |path|
      require path
      klass = path.sub(Dir.pwd + "/checks" + "/", "").sub(/\.rb$/, '').camelize
      checks.push Kernel.const_get(klass)
    end
    checks
  end

  def self.redis
    @redis ||= Redis.new(url: ENV["REDIS_URL"])
  end

  def self.logger
    @logger ||= Logger.new(STDERR)
  end
end
