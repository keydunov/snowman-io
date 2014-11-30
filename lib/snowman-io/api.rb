require 'sinatra'

module SnowmanIO
  class API < Sinatra::Base
    def self.start(options)
      sinatra_options = {}
      sinatra_options[:port] = options[:port]
      run!(sinatra_options)
    end

    get "/" do
      "SnowManIO Home Page"
    end
  end
end
