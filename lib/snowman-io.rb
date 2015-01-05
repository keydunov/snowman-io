require 'logger'
require 'bcrypt'
require 'celluloid/autostart'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/strip'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/hash/except'

require "snowman-io/version"
require "snowman-io/api"
require "snowman-io/options"
require "snowman-io/launcher"
require "snowman-io/cli"
require 'snowman-io/web_server'
require "snowman-io/adapter/base"
require "snowman-io/adapter/redis"
require "snowman-io/adapter/mongo"
require "snowman-io/models/collector"

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

      # Try all posible Heroku Mongo addons one after another
      mongo_url =
        ENV["MONGOHQ_URL"] ||
        ENV["MONGOLAB_URI"] ||
        ENV["MONGOSOUP_URL"] ||
        ENV["MONGO_URL"]

      if redis_url
        Adapter::Redis.new(redis_url)
      elsif mongo_url
        Adapter::Mongo.new(mongo_url)
      else
        raise "coundn't find any storage url"
      end
    end
  end

  def self.logger
    @logger ||= Logger.new(STDERR)
  end
end
