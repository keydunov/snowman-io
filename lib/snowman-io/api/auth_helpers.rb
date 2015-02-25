module SnowmanIO
  module API
    module AuthHelpers
      extend ActiveSupport::Concern
      TOKEN_REGEX = /^Token /
      AUTHN_PAIR_DELIMITERS = /(?:,|;|\t+)/

      included do
        helpers do
          def authenticate!
            current_user || render_unauthorized
          end

          def render_unauthorized
            error! 'Unauthorized', 401, 'WWW-Authenticate' => 'Token realm="Application"'
          end

          def current_user
            @current_user ||= authenticate_user_from_token
          end

          def authenticate_user_from_token
            authenticate_with_http_token do |token, options|
              user_email    = options[:email]
              user_email && User.find_by_email_and_authentication_token(user_email, token)
            end
          end

          def authenticate_with_http_token(&login_procedure)
            token, options = token_and_options
            unless token.blank?
              login_procedure.call(token, options)
            end
          end

          def token_and_options
            return if authorization_request.blank?

            if authorization_request.to_s[TOKEN_REGEX]
              params = token_params_from authorization_request
              [params.shift.last, Hash[params].with_indifferent_access]
            end
          end

          def authorization_request
            headers["Authorization"]
          end

          def token_params_from(auth)
            rewrite_param_values(params_array_from(raw_params(auth)))
          end

          # Takes raw_params and turns it into an array of parameters
          def params_array_from(raw_params)
            raw_params.map { |param| param.split %r/=(.+)?/ }
          end

          # This removes the `"` characters wrapping the value.
          def rewrite_param_values(array_params)
            array_params.each { |param| param.last.gsub! %r/^"|"$/, '' }
          end

          # pairs by the standardized `:`, `;`, or `\t` delimiters defined in
          # `AUTHN_PAIR_DELIMITERS`.
          def raw_params(auth)
            auth.sub(TOKEN_REGEX, '').split(/"\s*#{AUTHN_PAIR_DELIMITERS}\s*/)
          end

        end
      end
    end
  end
end
