module SnowmanIO
  module API
    class HgMetrics < Grape::API
      before(&:authenticate!)

      namespace :hg_metrics do
        params do
          requires :hg_metric, type: Hash do
            requires :app_id, type: String
            requires :name, type: String
            requires :metric_name, type: String
            requires :kind, type: String
          end
        end
        post do
          app = App.find(permitted_params[:hg_metric][:app_id])
          { hg_metric: app.hg_metrics.create!(permitted_params[:hg_metric].to_h.except("app_id")) }
        end

        route_param :id do
          before do
            @hg_metric = HgMetric.find(params[:id])
          end

          get do
            { hg_metric: @hg_metric }
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
