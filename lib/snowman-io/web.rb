require 'sinatra'

module SnowmanIO
  class Web < Sinatra::Base
    set :public_folder, File.dirname(__FILE__) + "/ui"
    set :views, File.dirname(__FILE__) + "/ui"

    before do
      unless Setting.get(SnowmanIO::BASE_URL_KEY).present?
        Setting.set(SnowmanIO::BASE_URL_KEY, request.base_url)
      end
    end

    get "/ping" do
      "PONG"
    end

    # Ember application
    get '/*' do
      send_file File.expand_path("../ui/index.html", __FILE__)
    end
  end
end
