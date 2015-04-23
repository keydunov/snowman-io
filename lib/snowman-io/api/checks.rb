module SnowmanIO
  module API
    class Checks < Grape::API
      before(&:authenticate!)

      namespace :checks do
        params do
          optional :last, type: Integer
        end
        get do
          Extra::Meteor.model_all(:checks, Check, permitted_params[:last])
        end

        params do
          requires :check, type: Hash do
            requires :metric_id, type: String
            requires :cmp, type: String
            requires :value, type: Float
          end
        end
        post do
          metric = Metric.find(permitted_params[:check][:metric_id])
          { check: metric.checks.create!(permitted_params[:check].to_h.except("metric_id")) }
        end

        route_param :id do
          before do
            @check = Check.find(params[:id])
          end

          get do
            { check: @check }
          end

          params do
            requires :check, type: Hash do
              requires :metric_id, type: String
              requires :cmp, type: String
              requires :value, type: Float
            end
          end
          put do
            { check: @check.tap { |m| m.update_attributes!(permitted_params[:check].to_h.except("metric_id")) } }
          end

          delete do
            Extra::Meteor.model_destroy(Check, @check)
          end
        end
      end
    end
  end
end
