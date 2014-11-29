require 'sinatra'

module SnowmanIO
  class API < Sinatra::Base
    set :port, ENV['PORT'] || 4567

    get "/" do
      "SnowManIO Home Page"
    end
  end
end
