require 'logger'
require 'bcrypt'
require 'celluloid/autostart'
require 'action_mailer'
require 'premailer'
require 'mongoid'
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
require "snowman-io/web"
require "snowman-io/api"
require "snowman-io/options"
require "snowman-io/launcher"
require "snowman-io/cli"
require "snowman-io/web_server"
require "snowman-io/aggregate"
require "snowman-io/reports"
require "snowman-io/loop/ping"
require "snowman-io/loop/main"
require "snowman-io/loop/checks"
require "snowman-io/report_mailer"

require "snowman-io/models/concerns/tokenable"
require "snowman-io/models/user"
require "snowman-io/models/app"
require "snowman-io/models/metric"
require "snowman-io/models/hg_metric"
require "snowman-io/models/check"
require "snowman-io/models/data_point"
require "snowman-io/models/aggregation"
require "snowman-io/models/setting"

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.view_paths = File.dirname(__FILE__) + "/snowman-io/views"
if ENV["DEV_MODE"].to_i == 1
  Object.send(:remove_const, :Rails)
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
  ADMIN_PASSWORD_KEY = "admin_password_hash"
  BASE_URL_KEY = "base_url"
  NEXT_REPORT_DATE = "next_report_date"
  HG_STATUS = "hg_status"
  HG_KEY = "hg_key"

  def self.logger
    @logger ||= Logger.new(STDERR)
  end

  def self.report_recipients
    User.order_by(:email => :asc).map(&:email)
  end
end

Mongoid.load!(File.expand_path("../config/mongoid.yml", __FILE__), :production)
