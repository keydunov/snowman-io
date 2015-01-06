module SnowmanIO
  module Loop
    class Report
      include Celluloid

      def initialize
        async.tick
      end

      def tick
        report_time = Time.now.beginning_of_day

        if time_for_reporting?(report_time)
          report(report_time)
        end

        after(600) { tick }
      end

      private

      # Send report at 7 o'clock every day
      def time_for_reporting?(at)
        key = Utils.date_to_key(at)
        Time.now > at + 7.hours && !SnowmanIO.storage.reports_find(key)
      end

      def report(at)
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
        SnowmanIO.storage.reports_create(key, {body: out, at: Time.now})
      end
    end
  end
end
