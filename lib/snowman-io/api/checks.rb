module SnowmanIO
  module API
    class Checks < Grape::API
      before(&:authenticate!)

      namespace :checks do
        params do
          requires :check, type: Hash do
            requires :hg_metric_id, type: String
            requires :cmp, type: String
            requires :value, type: Float
          end
        end
        post do
          hg_metric = HgMetric.find(permitted_params[:check][:hg_metric_id])
          { check: hg_metric.checks.create!(permitted_params[:check].to_h.except("hg_metric_id")) }
        end

        route_param :id do
          before do
            @check = Check.find(params[:id])
          end

          get do
            { check: @check }
          end

        #   params do
        #     requires :hg_metric, type: Hash do
        #       requires :app_id, type: String
        #       requires :name, type: String
        #       requires :metric_name, type: String
        #       requires :kind, type: String
        #     end
        #   end
        #   put do
        #     { hg_metric: @hg_metric.tap { |m| m.update_attributes!(permitted_params[:hg_metric].to_h.except("app_id")) } }
        #   end
        #
        #   delete do
        #     @hg_metric.destroy
        #   end
        end
      end
    end
  end
end
