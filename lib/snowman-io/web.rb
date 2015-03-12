require 'sinatra'

module SnowmanIO
  class Web < Sinatra::Base
    set :public_folder, File.dirname(__FILE__) + "/ui"
    set :views, File.dirname(__FILE__) + "/ui"

    before do
      unless SnowmanIO.storage.get(Storage::BASE_URL_KEY).present?
        SnowmanIO.storage.set(Storage::BASE_URL_KEY, request.base_url)
      end
    end

    get "/ping" do
      "PONG"
    end

    post '/agent/metrics' do
      payload = JSON.load(request.body.read)
      if app = App.find_by_token(payload["token"])
        payload["metrics"].each do |metric|
          options = { at: metric['at'], kind: metric['kind'], app: app }
          SnowmanIO.storage.metrics_register_value(metric["name"], metric["value"].to_f, options)
        end
        "OK"
      else
        "WRONG APP"
      end
    end

    # Ember application
    get '/*' do
      send_file File.expand_path("../ui/index.html", __FILE__)
    end
  end
end
