require 'snowman-io'
require 'capybara/rspec'
require 'celluloid/rspec'
require 'coveralls'
require 'timecop'
Coveralls.wear!

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

ENV["REDIS_URL"] = "redis://localhost:6379/db1"
Capybara.save_and_open_page_path = Dir.tmpdir + "/snowman-io-capybara"

RSpec.configure do |c|
  c.include AdminHelper
  c.before(:each) { SnowmanIO.redis.select(5) }
  c.after(:each) { SnowmanIO.redis.flushdb }
end
