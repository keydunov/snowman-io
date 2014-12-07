require 'sinatra'
require 'sinatra/content_for'

module SnowmanIO
  class API < Sinatra::Base
    def self.start(options)
      sinatra_options = {}
      sinatra_options[:port] = options[:port]
      run!(sinatra_options)
    end

    enable :sessions
    helpers Sinatra::ContentFor
    set :public_folder, File.dirname(__FILE__) + "/api/public"
    set :views, File.dirname(__FILE__) + "/api/views"
    set :session_secret, ENV['SESSION_SECRET'] || 'super secret'

    ADMIN_PASSWORD_KEY = "admin_password_hash"

    def admin_exists?
      !!SnowmanIO.redis.get(ADMIN_PASSWORD_KEY)
    end

    def admin_authenticated?
      admin_exists? && !!session[:user]
    end

    before do
      if request.path =~ /^\/api/
        if !admin_authenticated?
          # Ignore authorization only during app development
          halt 403, 'Access Denied' unless ENV["EMBER_DEV"].to_i == 1
        end
      else
        if !admin_exists?
          redirect to('/unpacking') if request.path_info != '/unpacking'
        elsif !admin_authenticated?
          redirect to('/login') if request.path_info != '/login'
        end
      end
    end

    get "/" do
      erb :index, layout: false
    end

    get "/login" do
      erb :login
    end

    post "/login" do
      if BCrypt::Password.new(SnowmanIO.redis.get(ADMIN_PASSWORD_KEY)) == params["password"]
        session[:user] = "admin"
        redirect to('/')
      else
        @wrong_password_warning = true
        erb :login
      end
    end

    get "/logout" do
      session[:user] = nil
      redirect to("/login")
    end

    get "/unpacking" do
      erb :unpacking
    end

    post "/unpacking" do
      if params["password"].empty?
        @empty_password_warning = true
        erb :unpacking
      else
        session[:user] = "admin"
        SnowmanIO.redis.set(ADMIN_PASSWORD_KEY, BCrypt::Password.create(params["password"]))
        redirect to('/')
      end
    end

    get "/api/checks" do
      if ENV["EMBER_DEV"].to_i == 1
        # Enable CORS in development mode
        response.headers['Access-Control-Allow-Origin'] = '*'
      end

      content_type :json
      {
        checks: [
          {id: 1, name: "First check from server"},
          {id: 2, name: "Second check from server"}
        ]
      }.to_json
    end
  end
end
