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

          params do
            requires :hg_metric, type: Hash do
              requires :app_id, type: String
              requires :name, type: String
              requires :metric_name, type: String
              requires :kind, type: String
            end
          end
          put do
            { hg_metric: @hg_metric.tap { |m| m.update_attributes!(permitted_params[:hg_metric].to_h.except("app_id")) } }
          end

          delete do
            @hg_metric.destroy
          end
        end
      end
    end
  end
end
