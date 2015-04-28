require 'grape'

require 'snowman-io/api/extra/meteor'
require 'snowman-io/api/auth_helpers'
require 'snowman-io/api/users'
require 'snowman-io/api/apps'
require 'snowman-io/api/info'
require 'snowman-io/api/metrics'
require 'snowman-io/api/checks'
require 'snowman-io/api/agent'

module SnowmanIO
  module API
    class Root < Grape::API
      include AuthHelpers
      default_format :json
      format :json
      default_error_formatter :json

      rescue_from Mongoid::Errors::Validations do |e|
        response = {errors: e.document.errors}
        rack_response response.to_json, 400
      end

      helpers do
        def permitted_params
          @permitted_params ||= declared(params, include_missing: false)
        end
      end

      mount Agent

      prefix :api
      mount Users
      mount Apps
      mount Info
      mount Metrics
      mount Checks
    end
  end
end
