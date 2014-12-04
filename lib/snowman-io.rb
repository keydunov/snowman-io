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
    @redis ||= Redis.new(url: ENV["REDIS_URL"])
  end

  def self.logger
    @logger ||= Logger.new(STDERR)
  end
end
