module SnowmanIO
  module Aggregate
    # Aggregate 5mins metrics
    def self.metrics_aggregate_5min
      Metric.all.each do |metric|
        aggr = {}

        # collect
        metric.data_points.each do |point|
          key = Utils.floor_5min(point.at)
          aggr[key] ||= []
          aggr[key] << point.value
        end

        # aggregrate
        aggr.each do |at, values|
          metric.aggregations.where(precision: "5min", at: at).first_or_create!.update_attributes!(
            count: values.length,
            min: values.min,
            avg: Utils.avg(values),
            up: Utils.up(values),
            max: values.max,
            sum: values.inject(&:+)
          )
        end
      end
    end

    # Aggregate daily metrics
    def self.metrics_aggregate_daily
      Metric.all.each do |metric|
        out = {}
        metric.aggregations.where(precision: "5min").each do |aggr|
          key = aggr.at.beginning_of_day
          out[key] ||= {"count" => 0, "avg" => 0, "up" => 0, "sum" => 0}
          out[key]["count"] += aggr["count"]
          out[key]["min"] = aggr["min"] if !out[key]["min"] || out[key]["min"] > aggr["min"]
          out[key]["avg"] += aggr["avg"]*aggr["count"]
          out[key]["up"] += aggr["up"]*aggr["count"]
          out[key]["max"] = aggr["max"] if !out[key]["max"] || out[key]["max"] < aggr["max"]
          out[key]["sum"] += aggr["sum"]
        end

        # normalize
        out.each do |__, chunk|
          chunk["avg"] /= chunk["count"]
          chunk["up"] /= chunk["count"]
        end

        # store
        out.each do |at, chunk|
          metric.aggregations.where(precision: "daily", at: at).first_or_create!.update_attributes!(chunk)
        end
      end
    end

    # Clean old records
    def self.metrics_clean_old
      now = Time.now
      DataPoint.where(:at.lt => Utils.floor_5min(now - 1.minutes)).delete_all
      SnowmanIO::Aggregation.where(precision: "5min", :at.lt => (now - 25.hours).beginning_of_day).delete_all
      SnowmanIO::Aggregation.where(precision: "daily", :at.lt => (now - 365.days).beginning_of_day).delete_all
    end
  end
end
