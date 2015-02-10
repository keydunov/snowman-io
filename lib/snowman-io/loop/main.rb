module SnowmanIO
  module Loop
    class Main
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
        now = Time.now
        next_report_date = Time.now.beginning_of_day

        # aggregate
        start = Time.now.to_f
        SnowmanIO.storage.metrics_aggregate_5min
        SnowmanIO.storage.metrics_aggregate_daily
        SnowmanIO.storage.metrics_clean_old

        unless SnowmanIO.storage.get(Storage::NEXT_REPORT_DATE)
          SnowmanIO.storage.set(Storage::NEXT_REPORT_DATE, next_report_date.to_i)
        end

        # send report at 7:00
        if now.to_i > SnowmanIO.storage.get(Storage::NEXT_REPORT_DATE) + 1.day + 7.hours
          SnowmanIO.storage.report_send(Time.at(SnowmanIO.storage.get(Storage::NEXT_REPORT_DATE)))
          SnowmanIO.storage.set(Storage::NEXT_REPORT_DATE, next_report_date.to_i)
        end
      end
    end
  end
end
