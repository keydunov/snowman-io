require 'snowman-io'
require 'capybara/rspec'
require 'celluloid/rspec'
require 'coveralls'
require 'timecop'
Coveralls.wear!

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }
ENV["MONGO_URL"] = "mongodb://localhost:27017/test"
Capybara.save_and_open_page_path = Dir.tmpdir + "/snowman-io-capybara"

RSpec.configure do |c|
  c.include AdminHelper

  c.before(:each) {
    SnowmanIO.mongo.client.drop_database("test")
  }
end
