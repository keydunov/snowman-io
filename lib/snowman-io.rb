require 'logger'
require 'bcrypt'
require 'mongo'
require 'celluloid/autostart'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/strip'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/time/calculations'

require "snowman-io/version"
require "snowman-io/utils"
require "snowman-io/api"
require "snowman-io/options"
require "snowman-io/launcher"
require "snowman-io/cli"
require "snowman-io/web_server"
require "snowman-io/collectors/hosted_graphite"
require "snowman-io/storage"
require "snowman-io/loop/collect"

module SnowmanIO
  def self.mongo
    @mongo ||= begin
      # Try all posible Heroku Mongo addons one after another
      url =
        ENV["MONGOHQ_URL"] ||
        ENV["MONGOLAB_URI"] ||
        ENV["MONGOSOUP_URL"] ||
        ENV["MONGO_URL"]

      if url
        db_name = url[%r{/([^/\?]+)(\?|$)}, 1]
        client = ::Mongo::MongoClient.from_uri(url)
        Struct.new(:client, :db).new(client, client.db(db_name))
      else
        raise "coundn't find any storage url"
      end
    end
  end

  def self.storage
    @storage ||= Storage.new
  end

  def self.logger
    @logger ||= Logger.new(STDERR)
  end
end
