module SnowmanIO
  module StorageImpl
    module Metrics
      def metrics_register_value(app, name, kind, value, at)
        metric = app.metrics.where(name: name, kind: kind).first_or_create!
        metric.update_attributes!(last_value: value)
        metric.data_points.create!(at: at, value: value)
      end

      def daily_metrics_for_app(app, at)
        json = {}
        metric = app.metrics.where(kind: "request").first

        today = at.beginning_of_day
        yesterday = at.beginning_of_day - 1.day
        json["today"] = {"at" => today.strftime("%Y-%m-%d")}
        json["yesterday"] = {"at" => yesterday.strftime("%Y-%m-%d")}

        if metric && (aggr = metric.aggregations.where(precision: "daily", at: today).first)
          json["today"]["count"] =  aggr.count.to_i
        end

        if metric && (aggr = metric.aggregations.where(precision: "daily", at: yesterday).first)
          json["yesterday"]["count"] = aggr.count.to_i
        end

        if metric
          json["total"] = {"count" => metric.aggregations.where(precision: "daily").sum(:count).to_i}
        end

        json
      end
    end
  end
end
