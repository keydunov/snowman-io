require 'json'
require 'open-uri'
require "active_support/time"

require 'snowman-io/notifiers/base'
require 'snowman-io/notifiers/slack'
require 'snowman-io/notifiers/mail'
require 'snowman-io/notifiers/console'

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
        @notifiers ||= [
          Notifiers::Console,
          Notifiers::Slack,
          Notifiers::Mail
        ].select { |notifier| notifier.configured? }
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
      CheckResult.new(self.class, status, message, get_context)
    end

    def ok?
      raise "Implement ok? in check class"
    end

    private

    def get_context
      instance_variables.map { |v| {key: v.to_s.sub(/^@/, ''), value: instance_variable_get(v)} }
    end
  end
end
