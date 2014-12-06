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
require "snowman-io/cli"

module SnowmanIO
  def self.redis
    # Try all posible Heroku Redis addons one after another
    url = 
      ENV["REDISTOGO_URL"] ||
      ENV["REDISCLOUD_URL"] ||
      ENV["OPENREDIS_URL"] ||
      ENV["REDISGREEN_URL"] ||
      ENV["REDIS_URL"]
    @redis ||= Redis.new(url: url)
  end

  def self.logger
    @logger ||= Logger.new(STDERR)
  end
end
