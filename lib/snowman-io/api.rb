require 'sinatra'

module SnowmanIO
  class API < Sinatra::Base
    def self.start(options)
      sinatra_options = {}
      sinatra_options[:port] = options[:port]
      sinatra_options[:public_folder] = File.dirname(__FILE__) + "/api/public"
      sinatra_options[:views] = File.dirname(__FILE__) + "/api/views"
      run!(sinatra_options)
    end

    get "/" do
      erb :index
    end
  end
end
