require 'grape'
if ENV["DEV_MODE"].to_i == 1
  require 'rack/cors'
end

require 'snowman-io/api/auth_helpers'
require 'snowman-io/api/users'
require 'snowman-io/api/apps'
require 'snowman-io/api/info'
require 'snowman-io/api/hg_metrics'

module SnowmanIO
  module API
    class Root < Grape::API
      include AuthHelpers
      prefix :api
      format :json
      default_error_formatter :json

      helpers do
        def permitted_params
          @permitted_params ||= declared(params, include_missing: false)
        end
      end

      if ENV["DEV_MODE"].to_i == 1
        use Rack::Cors do
          allow do
            origins '*'
            resource '*', headers: :any, methods: [:get, :post, :put, :delete]
          end
        end
      end
      
      mount Users
      mount Apps
      mount Info
      mount HgMetrics
    end
  end
end
