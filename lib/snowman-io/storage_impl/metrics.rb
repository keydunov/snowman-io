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

        if metric && (aggr = metric.aggregations.where(precision: "daily", at: at.beginning_of_day).first)
          json["today"] = {"count" => aggr.count}
        end

        if metric && (aggr = metric.aggregations.where(precision: "daily", at: at.beginning_of_day - 1.day).first)
          json["yesterday"] = {"count" => aggr.count}
        end

        if metric
          json["total"] = {"count" => metric.aggregations.where(precision: "daily").sum(:count)}
        end

        json
      end
    end
  end
end
