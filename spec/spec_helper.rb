ENV["MONGO_URL"] = "mongodb://localhost:27017/test"

require 'snowman-io'
require 'celluloid/rspec'
require 'coveralls'
require 'timecop'
require 'rack/test'
Coveralls.wear!

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

include SnowmanIO

module Helpers
  def app
    API::Root
  end

  def login_as(user)
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive(:current_user).and_return(user)
    end
  end

  def json_response
    JSON.parse(last_response.body)
  end
  alias_method :last_response_parsed, :json_response

end

RSpec.configure do |config|
  config.include Helpers
  config.include Rack::Test::Methods

  config.before(:each) {
    SnowmanIO.mongo.client.drop_database("test")
  }
end
