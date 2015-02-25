module SnowmanIO
  module API
    class Apps < Grape::API
      before(&:authenticate!)

      namespace :apps do
        desc "List apps"
        get do
          { apps: SnowmanIO.storage.apps_all }
        end

        desc "Creates app"
        params do
          requires :app, type: Hash do
            requires :name, type: String
          end
        end
        post do
          { app: SnowmanIO.storage.apps_create(permitted_params[:app]) }
        end

        route_param :id do

          desc "Returns app"
          get do
            { app: SnowmanIO.storage.apps_find(params[:id]) }
          end

          desc "Updates app"
          params do
            requires :app, type: Hash do
              requires :name, type: String
            end
          end
          put do
            { app: SnowmanIO.storage.apps_update(params[:id], permitted_params[:app]) }
          end

          desc "Deletes app"
          delete do
            SnowmanIO.storage.apps_delete(params[:id])
          end

        end
      end
    end
  end
end
