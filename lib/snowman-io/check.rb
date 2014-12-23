require 'json'
require 'open-uri'
require "active_support/time"

require 'snowman-io/notifiers/slack'
require 'snowman-io/notifiers/mail'

module SnowmanIO
  class Check
    include Checks::HostedGraphite

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
          [self.name, @human].compact.join(": ")
        end
      end

      def notifiers
        @notifiers ||= [Notifiers::Slack, Notifiers::Mail].select { |notifier| notifier.configured? }
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
  end
end
