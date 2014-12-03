require 'json'
require 'open-uri'
require "active_support/time"

require 'snowman-io/notifiers/slack'

module SnowmanIO
  class Check
    DEFAULT_INTERVAL = 1.minute
    class << self
      def interval(value = nil)
        if value
          @interval = value
        else
          @interval || DEFAULT_INTERVAL
        end
      end

      def human(value = nil)
        if value
          @human = value
        else
          self.name + ": #{@human}"
        end
      end

      def notifiers
        @notifiers ||= [Notifiers::Slack].select { |notifier| notifier.configured? }
      end
    end

    def perform
      if ok?
        status = "success"
        message = self.class.human + " - OK"
      else
        status = "failed"
        message = self.class.human + " - FAIL"
      end
      CheckResult.new(self.class, status, message)
    end

    def ok?
      raise "Implement ok? in check class"
    end

    protected

    def get_hg_value(metric, options = {})
      access_key = ENV["HG_KEY"]
      raise "HG_KEY cannot be found" unless access_key
      base_url = "https://www.hostedgraphite.com#{access_key}/graphite/render"
      from = options[:from] || "-10mins"
      url = base_url + "?format=json&target=#{URI.escape metric}&from=#{from}"
      handle = open(url)
      raw_data = JSON.parse(handle.gets)
      raw = raw_data.first
      datapoints = raw['datapoints'].delete_if{|v| v.first.nil? }
      if datapoints.last
        datapoints.last.first
      end
    end
  end
end
