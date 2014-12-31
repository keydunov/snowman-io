require 'logger'
require 'bcrypt'
require 'celluloid/autostart'
require 'active_support/core_ext/string/strip' # for strip_heredoc

require "snowman-io/version"
require "snowman-io/api"
require "snowman-io/options"
require "snowman-io/checks/hosted_graphite"
require "snowman-io/check"
require "snowman-io/check_result"
require "snowman-io/store"

require "snowman-io/launcher"
require "snowman-io/cli"

require "snowman-io/adapter/base"
require "snowman-io/adapter/redis"

module SnowmanIO
  def self.adapter
    @adapter ||= begin
      # Try all posible Heroku Redis addons one after another
      redis_url =
        ENV["REDISTOGO_URL"] ||
        ENV["REDISCLOUD_URL"] ||
        ENV["OPENREDIS_URL"] ||
        ENV["REDISGREEN_URL"] ||
        ENV["REDIS_URL"]

      Adapter::Redis.new(redis_url)
    end
  end

  def self.store
    @store ||= Store.new
  end

  def self.logger
    @logger ||= Logger.new(STDERR)
  end
end
