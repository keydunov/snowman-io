require 'snowman-io/loop/check_processor'

module SnowmanIO
  module Loop
    class Checks
      include Celluloid

      def initialize
        after(1) { tick }
      end

      def tick
        perform
        after(3) { tick }
      end

      private

      def perform
        # Run checks only if hg enabled for now
        return if Setting.get(SnowmanIO::HG_STATUS) != "enabled"

        Check.active.each do |check|
          result = CheckProcessor.new(check).process
          check.last_run_at = DateTime.now
          if result
            puts "Check for #{check.metric.name} triggered"
            check.triggered = true
            # notify, send email...
          end
          check.save!
        end
      end
    end
  end
end
