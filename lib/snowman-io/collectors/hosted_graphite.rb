require 'open-uri' 

module SnowmanIO
  module Collectors
    # Gets last value from Hosted Graphite metric (https://www.hostedgraphite.com/)
    module HostedGraphite
      protected

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
