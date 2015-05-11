module SnowmanIO
  module API
    class Metrics < Grape::API
      before(&:authenticate!)

      namespace :metrics do
        params do
          optional :last, type: Integer
        end
        get do
          Extra::Meteor.model_all(:metrics, Metric, permitted_params[:last])
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
            Extra::Meteor.model_destroy(Metric, @metric)
          end

          # WIP
          # Returns data to render chart for metric
          params do
            requires :target, values: ["avg", "count"]
            optional :precision, values: ["5min", "daily"], default: "5min"
          end
          get "render" do
            data = @metric.aggregations
                     .where(precision: params[:precision])
                     .order("at desc")
                     .limit(36).sort_by(&:at).map do |datapoint|
                       { at: datapoint.at, value: datapoint.send(params[:target]) }
                     end
            { datapoints: data }
          end
        end
      end
    end
  end
end
