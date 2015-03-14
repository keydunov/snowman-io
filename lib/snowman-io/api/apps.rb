module SnowmanIO
  module API
    class Apps < Grape::API
      before(&:authenticate!)

      namespace :apps do
        desc "List apps"
        get do
          { apps: App.all  }
        end

        desc "Creates app"
        params do
          requires :app, type: Hash do
            requires :name, type: String
          end
        end
        post do
          { app: App.create(permitted_params[:app].to_h) }
        end

        route_param :id do
          before do
            @app = App.find(params[:id])
          end

          desc "Returns app"
          get do
            { app: @app }
          end

          desc "Updates app"
          params do
            requires :app, type: Hash do
              requires :name, type: String
            end
          end
          put do
            { app: @app.update_attributes(params[:app]) }
          end

          desc "Deletes app"
          delete do
            @app.destroy
          end

        end
      end
    end
  end
end
