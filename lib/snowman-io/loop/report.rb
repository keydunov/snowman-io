module SnowmanIO
  module Loop
    class Report
      include Celluloid

      def initialize(start_immediately = true)
        unless SnowmanIO.storage.get(Storage::NEXT_REPORT_FOR)
          schedule_next_report
        end
        SnowmanIO.logger.debug "report for: #{report_for}"

        if start_immediately
          async.tick
        end
      end

      def tick
        if time_for_reporting?
          process(report_for)
          schedule_next_report
        end

        after(600) { tick }
      end

      protected

      def schedule_next_report
        SnowmanIO.storage.set(Storage::NEXT_REPORT_FOR, Time.now.beginning_of_day.strftime("%Y-%m-%d"))
      end

      def report_for
        Time.parse(SnowmanIO.storage.get(Storage::NEXT_REPORT_FOR))
      end

      def time_for_reporting?
        # Send report at 7 o'clock next day
        Time.now > report_for + 1.day + 7.hours
      end

      def process(at)
        day = SnowmanIO.storage.metrics_daily(at)
        key = Utils.date_to_key(at)
        # TODO: use erb
        out = "<table class='table'>\n"
        out += "<tr>"
        out += "<th>Name</th>"
        out += "<th>Min</th>"
        out += "<th>Avg</th>"
        out += "<th>Max</th>"
        out += "</tr>\n"
        SnowmanIO.storage.metrics_all.each do |metric|
          out += "<tr>"
          out += "<td>#{metric["name"]}</td>"
          out += "<td>#{day.try(:[], metric["id"].to_s).try(:[], "min")}</td>"
          out += "<td>#{day.try(:[], metric["id"].to_s).try(:[], "avg")}</td>"
          out += "<td>#{day.try(:[], metric["id"].to_s).try(:[], "max")}</td>"
          out += "</tr>\n"
        end
        out += "</table>"
        ReportMailer.daily_report(at, out).deliver
        SnowmanIO.storage.reports_create(key, {body: out, at: Time.now})
      end
    end
  end
end
