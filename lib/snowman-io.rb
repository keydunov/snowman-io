require 'logger'
require 'bcrypt'
require 'mongo'
require 'celluloid/autostart'
require 'action_mailer'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/strip'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/time/calculations'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/enumerable'

require "snowman-io/version"
require "snowman-io/utils"
require "snowman-io/api"
require "snowman-io/options"
require "snowman-io/launcher"
require "snowman-io/cli"
require "snowman-io/web_server"
require "snowman-io/storage"
require "snowman-io/loop/ping"
require "snowman-io/loop/aggregate"
require "snowman-io/loop/report"
require "snowman-io/loop/report_mailer"

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.view_paths = File.dirname(__FILE__) + "/snowman-io/views"
if ENV["DEV_MODE"].to_i == 1
  require "letter_opener"
  ActionMailer::Base.add_delivery_method :letter_opener,
    LetterOpener::DeliveryMethod,
    :location => File.expand_path('../../tmp/letter_opener', __FILE__)
  ActionMailer::Base.delivery_method = :letter_opener
else
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address   => ENV["MAILGUN_SMTP_SERVER"],
    :port      => ENV["MAILGUN_SMTP_PORT"],
    :authentication => :plain,
    :user_name      => ENV["MAILGUN_SMTP_LOGIN"],
    :password       => ENV["MAILGUN_SMTP_PASSWORD"],
    :enable_starttls_auto => true
  }
end

module SnowmanIO
  def self.mongo
    @mongo ||= begin
      # Try all posible Heroku Mongo addons one after another
      url =
        ENV["MONGOHQ_URL"] ||
        ENV["MONGOLAB_URI"] ||
        ENV["MONGOSOUP_URL"] ||
        ENV["MONGO_URL"] ||
        "mongodb://localhost:27017/db"

      db_name = url[%r{/([^/\?]+)(\?|$)}, 1]
      client = ::Mongo::MongoClient.from_uri(url)
      Struct.new(:client, :db).new(client, client.db(db_name))
    end
  end

  def self.storage
    @storage ||= Storage.new
  end

  def self.logger
    @logger ||= Logger.new(STDERR)
  end
end
