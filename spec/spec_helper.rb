require 'snowman-io'
require 'capybara/rspec'
require 'celluloid/rspec'
require 'coveralls'
require 'timecop'
Coveralls.wear!

ENV["REDIS_URL"] = "redis://localhost:6379/db1"
Capybara.save_and_open_page_path = Dir.tmpdir + "/snowman-io-capybara"

module AdminHelper
  def register_admin(password)
    visit "/unpacking"
    fill_in "password", with: password
    click_button "Set Admin Password"
    visit "/logout"
  end
end

RSpec.configure do |c|
  c.include AdminHelper
  c.before(:each) { SnowmanIO.redis.select(5) }
  c.after(:each) { SnowmanIO.redis.flushdb }
end
