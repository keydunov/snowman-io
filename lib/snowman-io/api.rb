require 'sinatra'
require 'sinatra/content_for'

module SnowmanIO
  class API < Sinatra::Base
    enable :sessions
    helpers Sinatra::ContentFor
    set :public_folder, File.dirname(__FILE__) + "/api/public"
    set :views, File.dirname(__FILE__) + "/api/views"
    set :session_secret, ENV['SESSION_SECRET'] || 'super secret'

    def admin_exists?
      SnowmanIO.store.admin_password_setted?
    end

    def admin_authenticated?
      admin_exists? && !!session[:user]
    end

    before do
      if request.path =~ /^\/api/
        content_type :json

        if ENV["EMBER_DEV"].to_i == 1
          # Enable CORS in development mode
          response.headers['Access-Control-Allow-Origin'] = '*'
        end

        if !admin_authenticated?
          # Ignore authorization only during app development
          unless ENV["EMBER_DEV"].to_i == 1
            halt 403, 'Access Denied'
          end
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
      raise 'x'
      erb :index, layout: false
    end

    get "/login" do
      erb :login
    end

    post "/login" do
      if SnowmanIO.store.auth_admin?(params["password"])
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
      unless SnowmanIO.store.base_url
        SnowmanIO.store.set_base_url(request.base_url)
      end
      erb :unpacking
    end

    post "/unpacking" do
      if params["password"].empty?
        @empty_password_warning = true
        erb :unpacking
      else
        session[:user] = "admin"
        SnowmanIO.store.set_admin_password(params["password"])
        redirect to('/')
      end
    end

    get '/*' do
      erb :index, layout: false
    end
  end
end
