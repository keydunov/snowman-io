module SnowmanIO
  module API
    class Apps < Grape::API
      before(&:authenticate!)

      namespace :apps do
        params do
          optional :last, type: Integer
        end
        get do
          Extra::Meteor.model_all(:apps, App, permitted_params[:last])
        end

        desc "Creates app"
        params do
          requires :app, type: Hash do
            requires :name, type: String
          end
        end
        post do
          { app: App.create!(permitted_params[:app].to_h) }
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
            { app: @app.tap { |app| app.update_attributes!(permitted_params[:app].to_h) } }
          end

          desc "Deletes app"
          delete do
            Extra::Meteor.model_destroy(App, @app)
          end
        end
      end
    end
  end
end
