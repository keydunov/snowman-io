module SnowmanIO
  module API
    class Users < Grape::API
      namespace :users do
        desc "User signup "
        params do
          requires :user, type: Hash do
            requires :password, type: String
            requires :email, type: String
          end
        end
        post do
          if user = User.create(permitted_params[:user])
            { user: { email: user.email, authentication_token: user.authentication_token } }
          else
            # TODO
            status 400
            { message: user.errors }
          end
        end

        desc "User Signin"
        params do
          requires :user, type: Hash do
            requires :password, type: String
            requires :email, type: String
          end
        end
        post "login" do
          if (user = User.find_by_email(permitted_params[:user][:email])) && user.authenticate(permitted_params[:user][:password])
            { token: user.authentication_token, email: user.email }
          else
            status 400
            { message: "Wrong email or password" }
          end
        end
      end
    end
  end
end
