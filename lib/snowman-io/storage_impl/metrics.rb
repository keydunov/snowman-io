module SnowmanIO
  module StorageImpl
    module Metrics
      def metrics_register_value(app, name, kind, value, at)
        metric = app.metrics.where(name: name, kind: kind).first_or_create!
        metric.update_attributes!(last_value: value)
        metric.data_points.create!(at: at, value: value)
      end
    end
  end
end
