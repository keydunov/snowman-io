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
      SnowmanIO.storage.get(Storage::ADMIN_PASSWORD_KEY).present?
    end

    def admin_authenticated?
      admin_exists? && !!session[:user]
    end

    before do
      if request.path =~ /^\/api/
        if ENV["DEV_MODE"].to_i == 1
          # Enable CORS in development mode
          response.headers['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN']
          response.headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS, PUT, DELETE',
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
          unless ENV["DEV_MODE"].to_i == 1
            halt 403, 'Access Denied'
          end
        end
      # FIXME: temp workaround while we don't have token for agent
      elsif request.path !~ /^\/agent/
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
      if BCrypt::Password.new(SnowmanIO.storage.get(Storage::ADMIN_PASSWORD_KEY)) == params["password"]
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
      unless SnowmanIO.storage.get(Storage::BASE_URL_KEY).present?
        SnowmanIO.storage.set(Storage::BASE_URL_KEY, request.base_url)
      end
      erb :unpacking
    end

    post "/unpacking" do
      if params["password"].empty?
        @empty_password_warning = true
        erb :unpacking
      else
        session[:user] = "admin"
        SnowmanIO.storage.set(Storage::ADMIN_PASSWORD_KEY, BCrypt::Password.create(params["password"]))
        redirect to('/')
      end
    end

    get "/api/metrics" do
      { metrics: SnowmanIO.storage.metrics_all(only_new: !!params[:new]) }.to_json
    end

    get "/api/metrics/:id" do
      { metric: SnowmanIO.storage.metrics_find(params[:id]) }.to_json
    end

    get "/api/reports" do
      { reports: SnowmanIO.storage.reports_all }.to_json
    end

    get "/api/reports/:id" do
      { report: SnowmanIO.storage.reports_find(params[:id]) }.to_json
    end

    get "/api/info" do
      {
        base_url: SnowmanIO.storage.get(Storage::BASE_URL_KEY),
        version: SnowmanIO::VERSION
      }.to_json
    end

    get "/api/dashboard" do
      SnowmanIO.storage.dashboard.to_json
    end

    post '/agent/metrics' do
      JSON.load(request.body.read)["metrics"].each do |metric|
        options = { at: metric['at'], kind: metric['kind'] }
        SnowmanIO.storage.metrics_register_value(metric["name"], metric["value"].to_f, options)
      end
      "OK"
    end

    get '/*' do
      erb :index, layout: false
    end
  end
end
