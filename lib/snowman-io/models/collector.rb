module SnowmanIO
  module Models
    class Collector
      def self.all
        SnowmanIO.adapter.keys("collectors@*").map do |key|
          SnowmanIO.adapter.get(key)
        end
      end

      def self.find(id)
        SnowmanIO.adapter.get("collectors@#{id}")
      end

      def self.create(options)
        hr = {}
        if options["kind"] == "HG"
          if options["hgMetric"].present?
            id = SnowmanIO.adapter.incr(API::GLOBAL_ID_KEY)
            collector = {
              id: id,
              kind: options["kind"],
              hgMetric: options["hgMetric"]
            }
            SnowmanIO.adapter.set("collectors@#{id}", collector)
            hr[:status] = :ok
            hr[:collector] = collector
          else
            hr[:status] = :failed
            hr[:errors] = {
              "hgMetric" => ["HG Metric should not be empty"]
            }
          end
        else
          raise "I dont know how to create collector with #{options.inspect}"
        end
        hr
      end
    end
  end
end
