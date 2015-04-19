module SnowmanIO
  module API
    class Metrics < Grape::API
      before(&:authenticate!)

      namespace :metrics do
        params do
          requires :metric, type: Hash do
            requires :app_id, type: String
            requires :name, type: String
            requires :source, type: String
            requires :kind, type: String
            optional :metric_name, type: String
          end
        end
        post do
          app = App.find(permitted_params[:metric][:app_id])
          { metric: app.metrics.create!(permitted_params[:metric].to_h.except("app_id")) }
        end

        route_param :id do
          before do
            @metric = Metric.find(params[:id])
          end

          get do
            { metric: @metric }
          end

          params do
            requires :metric, type: Hash do
              requires :app_id, type: String
              requires :name, type: String
              requires :source, type: String
              requires :kind, type: String
              optional :metric_name, type: String
            end
          end
          put do
            { metric: @metric.tap { |m| m.update_attributes!(permitted_params[:metric].to_h.except("app_id")) } }
          end

          delete do
            @metric.destroy
          end
        end
      end
    end
  end
end
