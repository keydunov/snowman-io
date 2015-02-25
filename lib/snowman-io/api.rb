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

    helpers do
      def request_headers
        env.inject({}){|acc, (k,v)| acc[$1.downcase] = v if k =~ /^http_(.*)/i; acc}
      end

      def set_base_url_key
        unless SnowmanIO.storage.get(Storage::BASE_URL_KEY).present?
          SnowmanIO.storage.set(Storage::BASE_URL_KEY, request.base_url)
        end
      end

      # TODO
      def authenticate!
        unless request_headers['authorization'] == 'Token token="token", email="admin"'
          halt 403, 'Access Denied'
        end
      end
    end

    before do
      set_base_url_key

      if request.path =~ /^\/api/

        # TODO: make it as a middleware
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
      elsif request.path =~ /^\/agent/
        # do nonthing
      else
        if !admin_exists?
          redirect to('/unpacking') if request.path_info != '/unpacking'
        elsif !admin_authenticated?
          redirect to('/login') if request.path_info != '/login'
        end
      end
    end

    get "/ping" do
      "PONG"
    end

    # Create user
    post "/api/users" do
      payload = JSON.load(request.body.read)
      halt 400 if payload["user"]["password"].blank? || payload["user"]["email"].blank?

      if user = User.create(payload["user"])
        JSON.dump({ user: { email: user.email, authentication_token: user.authentication_token } })
      else
        hasl 400, "bad request"
      end
    end

    post "/api/users/login" do
      if (user = User.find_by_email(params["user"]["email"])) && user.authenticate(params["user"]["password"])
        JSON.dump({ token: user["authentication_token"], email: user["email"] })
      else
        halt 401, JSON.dump({ message: "Wrong email or password" })
      end
    end

    get "/api/apps" do
      { "apps" => SnowmanIO.storage.apps_all }.to_json
    end

    get "/api/apps/:id" do
      { "app" => SnowmanIO.storage.apps_find(params[:id]) }.to_json
    end

    post "/api/apps" do
      { "app" => SnowmanIO.storage.apps_create(JSON.load(request.body.read)["app"]) }.to_json
    end

    put "/api/apps/:id" do
      { "app" => SnowmanIO.storage.apps_update(params[:id], JSON.load(request.body.read)["app"]) }.to_json
    end

    delete "/api/apps/:id" do
      { "app" => SnowmanIO.storage.apps_delete(params[:id]) }.to_json
    end

    get "/api/info" do
      {
        base_url: SnowmanIO.storage.get(Storage::BASE_URL_KEY),
        version: SnowmanIO::VERSION,
        report_recipients: SnowmanIO.report_recipients
      }.to_json
    end

    post '/agent/metrics' do
      payload = JSON.load(request.body.read)
      if app = SnowmanIO.storage.apps_find_by_token(payload["token"])
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
      erb :index, layout: false
    end
  end
end
