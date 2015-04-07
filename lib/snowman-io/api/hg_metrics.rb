module SnowmanIO
  module API
    class HgMetrics < Grape::API
      before(&:authenticate!)

      namespace :hgMetrics do
        # desc "List apps"
        # get do
        #   { apps: App.all }
        # end

        params do
          requires :hgMetric, type: Hash do
            requires :app, type: String
            requires :name, type: String
            requires :metricName, type: String
            requires :kind, type: String
          end
        end
        post do
          app = App.find(permitted_params[:hgMetric][:app])
          { hgMetric: app.hg_metrics.create!(permitted_params[:hgMetric].to_h.except("app")) }
        end

        route_param :id do
          before do
            @hg_metric = HgMetric.find(params[:id])
          end

          get do
            { hgMetric: @hg_metric }
          end

        #   desc "Updates app"
        #   # params do
        #   #   requires :app, type: Hash do
        #   #     requires :name, type: String
        #   #   end
        #   # end
        #   put do
        #     p params
        #     # { app: @app.tap { |app| app.update_attributes!(permitted_params[:app].to_h) } }
        #   end
        #
        #   desc "Deletes app"
        #   delete do
        #     @app.destroy
        #   end
        end
      end
    end
  end
end
