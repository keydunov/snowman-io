require 'snowman-io'
require 'capybara/rspec'
require 'coveralls'
Coveralls.wear!

ENV["REDIS_URL"] = "redis://localhost:6379/db1"
Capybara.save_and_open_page_path = Dir.tmpdir + "/snowman-io-capybara"

RSpec.configure do |c|
  c.before(:each) { SnowmanIO.redis.select(5) }
  c.after(:each) { SnowmanIO.redis.flushdb }
end
