module SnowmanIO
  module Loop
    class CollectWorker
      include Celluloid

      def collect(collector, at)
        if collector["kind"] == "HG"
          SnowmanIO.storage.metrics_register_value(
            collector["metricName"],
            get_hg_value(collector["hgMetric"]),
            at
          )
        else
          raise "I dont know how collect #{collector.inspect}"
        end
      end

      private

      def get_hg_value(metric, options = {})
        access_key = ENV["HG_KEY"]
        return nil unless access_key
        base_url = "https://www.hostedgraphite.com#{access_key}/graphite/render"
        from = options[:from] || "-10mins"
        url = base_url + "?format=json&target=#{URI.escape metric}&from=#{from}"
        handle = open(url)
        raw_data = JSON.parse(handle.gets)
        raw = raw_data.first
        datapoints = raw['datapoints'].delete_if { |v| v.first.nil? }
        if datapoints.last
          datapoints.last.first
        end
      rescue => e
        nil
      end
    end
  end
end
