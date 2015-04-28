module SnowmanIO
  module API
    class Agent < Grape::API
      namespace :agent do

        desc "Report metrics from agent"
        params do
          requires :token, type: String
          optional :metrics, type: Array
        end
        post "metrics" do
          if app = App.where(token: params[:token]).first
            params[:metrics].each do |metric|
              app.register_metric_value(metric["name"], metric["kind"], metric["value"].to_f, Time.now)
            end
            "OK"
          else
            "WRONG APP"
          end
        end

      end
    end
  end
end
