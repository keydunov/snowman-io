module SnowmanIO
  module StorageImpl
    module Aggregation
      # Aggregate 5mins metrics
      def metrics_aggregate_5min
        SnowmanIO.mongo.db["metrics"].find({}, fields: ["realtime"]).each do |metric|
          aggr = {}

          # collect
          metric["realtime"].each do |at, values|
            key = Utils.floor_5min(Time.at(at.to_i)).to_i
            aggr[key] ||= []
            aggr[key] += values
          end

          # aggregrate
          aggr.each do |key, values|
            SnowmanIO.mongo.db["metrics"].update(
              {"_id" => metric["_id"]},
              {"$set" => {
                "5min.#{key}.count" => values.length,
                "5min.#{key}.min" => values.min,
                "5min.#{key}.avg" => Utils.avg(values),
                "5min.#{key}.up" => Utils.up(values),
                "5min.#{key}.max" => values.max,
                "5min.#{key}.sum" => values.inject(&:+)
              }}
            )
          end
        end
      end

      # Aggregate daily metrics
      def metrics_aggregate_daily
        SnowmanIO.mongo.db["metrics"].find({}, fields: ["5min"]).each do |metric|
          next if metric["5min"].empty?

          out = {}

          # accumulate
          metric["5min"].each do |at, chunk|
            key = Time.at(at.to_i).beginning_of_day.to_i
            out[key] ||= {"count" => 0, "avg" => 0, "up" => 0, "sum" => 0}
            out[key]["count"] += chunk["count"]
            out[key]["min"] = chunk["min"] if !out[key]["min"] || out[key]["min"] > chunk["min"]
            out[key]["avg"] += chunk["avg"]*chunk["count"]
            out[key]["up"] += chunk["up"]*chunk["count"]
            out[key]["max"] = chunk["max"] if !out[key]["max"] || out[key]["max"] < chunk["max"]
            out[key]["sum"] += chunk["sum"]
          end

          # normalize
          out.each do |__, chunk|
            chunk["avg"] /= chunk["count"]
            chunk["up"] /= chunk["count"]
          end

          # transform
          daily = {}
          out.each do |key, chunk|
            daily["daily.#{key}.count"] = chunk["count"]
            daily["daily.#{key}.min"] = chunk["min"]
            daily["daily.#{key}.avg"] = chunk["avg"]
            daily["daily.#{key}.up"] = chunk["up"]
            daily["daily.#{key}.max"] = chunk["max"]
            daily["daily.#{key}.sum"] = chunk["sum"]
          end

          # store
          SnowmanIO.mongo.db["metrics"].update(
            {"_id" => metric["_id"]},
            {"$set" => daily}
          )
        end
      end

      # Clean old records
      def metrics_clean_old
        now = Time.now

        # clear realtime
        key_to_keep = Utils.floor_5min(now - 1.minutes).to_i
        SnowmanIO.mongo.db["metrics"].find({}, fields: ["realtime"]).each do |metric|
          unset = {}
          metric["realtime"].each do |key, __|
            if key.to_i < key_to_keep
              unset["realtime.#{key}"] = ""
            end
          end
          if unset.present?
            SnowmanIO.mongo.db["metrics"].update(
              {"_id" => metric["_id"]},
              {"$unset" => unset}
            )
          end
        end

        # clear 5 min
        key_to_keep = (now - 25.hours).beginning_of_day.to_i
        SnowmanIO.mongo.db["metrics"].find({}, fields: ["5min"]).each do |metric|
          unset = {}
          metric["5min"].each do |key, __|
            if key.to_i < key_to_keep
              unset["5min.#{key}"] = ""
            end
          end
          if unset.present?
            SnowmanIO.mongo.db["metrics"].update(
              {"_id" => metric["_id"]},
              {"$unset" => unset}
            )
          end
        end

        # clear daily
        key_to_keep = (now - 365.days).beginning_of_day.to_i
        SnowmanIO.mongo.db["metrics"].find({}, fields: ["daily"]).each do |metric|
          unset = {}
          metric["daily"].each do |key, __|
            if key.to_i < key_to_keep
              unset["daily.#{key}"] = ""
            end
          end
          if unset.present?
            SnowmanIO.mongo.db["metrics"].update(
              {"_id" => metric["_id"]},
              {"$unset" => unset}
            )
          end
        end
      end
    end
  end
end
