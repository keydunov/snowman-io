require 'sinatra'
require 'sinatra/content_for'

module SnowmanIO
  class API < Sinatra::Base
    ADMIN_PASSWORD_KEY = "admin_password_hash"
    BASE_URL_KEY = "base_url"
    GLOBAL_ID_KEY = "global_id"

    enable :sessions
    helpers Sinatra::ContentFor
    set :public_folder, File.dirname(__FILE__) + "/api/public"
    set :views, File.dirname(__FILE__) + "/api/views"
    set :session_secret, ENV['SESSION_SECRET'] || 'super secret'

    def admin_exists?
      SnowmanIO.adapter.get(ADMIN_PASSWORD_KEY).present?
    end

    def admin_authenticated?
      admin_exists? && !!session[:user]
    end

    before do
      if request.path =~ /^\/api/
        if ENV["EMBER_DEV"].to_i == 1
          # Enable CORS in development mode
          response.headers['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN']
          response.headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS',
          response.headers['Access-Control-Allow-Headers'] = "*, Content-Type, Accept, AUTHORIZATION, Cache-Control"
          response.headers['Access-Control-Allow-Credentials'] = "true"
          response.headers['Access-Control-Expose-Headers'] = "Cache-Control, Content-Language, Content-Type, Expires, Last-Modified, Pragma"
          if request.request_method == 'OPTIONS'
            halt 200
          end
        end

        content_type :json

        if !admin_authenticated?
          # Ignore authorization during app development
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
      erb :index, layout: false
    end

    get "/login" do
      erb :login
    end

    post "/login" do
      if BCrypt::Password.new(SnowmanIO.adapter.get(ADMIN_PASSWORD_KEY)) == params["password"]
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
      unless SnowmanIO.adapter.get(BASE_URL_KEY).present?
        SnowmanIO.adapter.set(BASE_URL_KEY, request.base_url)
      end
      erb :unpacking
    end

    post "/unpacking" do
      if params["password"].empty?
        @empty_password_warning = true
        erb :unpacking
      else
        session[:user] = "admin"
        SnowmanIO.adapter.set(ADMIN_PASSWORD_KEY, BCrypt::Password.create(params["password"]))
        redirect to('/')
      end
    end

    get "/api/collectors" do
      keys = SnowmanIO.adapter.keys("collectors@*")
      {
        collectors: keys.map{ |key|
          SnowmanIO.adapter.get(key)
        }
      }.to_json
    end

    post "/api/collectors" do
      payload = JSON.load(request.body.read)["collector"]

      if payload["hgMetric"].present?
        id = SnowmanIO.adapter.incr(GLOBAL_ID_KEY)
        collector = {
          id: id,
          kind: payload["kind"],
          hgMetric: payload["hgMetric"]
        }
        SnowmanIO.adapter.set("collectors@#{id}", collector)
        {
          collector: collector
        }.to_json
      else
        status 422
        {
          errors: {
            "hgMetric" => ["HG Metric should not be empty"]
          }
        }.to_json
      end
    end

    get "/api/collectors/:id" do
      {
        collector: SnowmanIO.adapter.get("collectors@#{params[:id]}")
      }.to_json
    end

    get "/api/status" do
      {
        base_url: SnowmanIO.adapter.get(BASE_URL_KEY)
      }.to_json
    end

    get '/*' do
      erb :index, layout: false
    end
  end
end
