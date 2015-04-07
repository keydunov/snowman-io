require 'grape'

require 'snowman-io/api/auth_helpers'
require 'snowman-io/api/users'
require 'snowman-io/api/apps'
require 'snowman-io/api/info'

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

      mount Users
      mount Apps
      mount Info
    end
  end
end
