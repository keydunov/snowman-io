require 'logger'
require 'bcrypt'
require 'celluloid/autostart'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/strip'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/time/calculations'

require "snowman-io/version"
require "snowman-io/api"
require "snowman-io/options"
require "snowman-io/launcher"
require "snowman-io/cli"
require "snowman-io/web_server"
require "snowman-io/collectors/hosted_graphite"
require "snowman-io/adapter/mongo"
require "snowman-io/models/collector"
require "snowman-io/models/metric"
require "snowman-io/engine"

module SnowmanIO
  def self.mongo
    @mongo ||= begin
      # Try all posible Heroku Mongo addons one after another
      mongo_url =
        ENV["MONGOHQ_URL"] ||
        ENV["MONGOLAB_URI"] ||
        ENV["MONGOSOUP_URL"] ||
        ENV["MONGO_URL"]

      if mongo_url
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
