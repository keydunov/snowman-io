require 'snowman-io'
require 'capybara/rspec'
require 'celluloid/rspec'
require 'coveralls'
require 'timecop'
Coveralls.wear!

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

if ENV["REDIS"] == '1'
  ENV["REDIS_URL"] = "redis://localhost:6379"
else
  # use mongo by default
  ENV["MONGO_URL"] = "mongodb://localhost:27017/test"
end
Capybara.save_and_open_page_path = Dir.tmpdir + "/snowman-io-capybara"
puts "[DEBUG] SnowmanIO.adapter.kind = #{SnowmanIO.adapter.kind}"

RSpec.configure do |c|
  c.include AdminHelper

  c.before(:each) {
    case SnowmanIO.adapter.kind
    when :redis
      SnowmanIO.adapter.instance_variable_get(:@redis).select(5)
    when :mongo
      # do nothing
    else
      raise "add support of this adapter kind if you need it"
    end
  }
  c.after(:each) {
    case SnowmanIO.adapter.kind
    when :redis
      SnowmanIO.adapter.instance_variable_get(:@redis).flushdb
    when :mongo
      SnowmanIO.adapter.instance_variable_get(:@coll).remove
    else
      raise "add support of this adapter kind if you need it"
    end
  }
end
