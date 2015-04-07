module SnowmanIO
  module API
    class Users < Grape::API
      namespace :users do
        desc "User signup"
        params do
          requires :user, type: Hash do
            requires :password, type: String
            requires :email, type: String
          end
        end
        post do
          user = User.create!(permitted_params[:user].to_h)
          { user: { email: user.email, authentication_token: user.authentication_token } }
        end

        desc "User Signin"
        params do
          requires :user, type: Hash do
            requires :email, type: String
            optional :password, type: String
          end
        end
        post "login" do
          email = permitted_params[:user][:email]
          password = permitted_params[:user][:password]
          if (user = User.where(email: email).first) && password.present? && user.authenticate(password)
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
