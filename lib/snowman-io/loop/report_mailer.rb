module SnowmanIO
  module Loop
    class ReportMailer < ActionMailer::Base
      def daily_report(at, body)
        mail(
          to: ["vakhov@gmail.com", "artyom.keydunov@gmail.com"],
          from: "no-reply@example.com",
          subject: "SnowmanIO daily report at #{at.strftime("%Y-%m-%d")}"
        ) do |format|
          format.html {
            render text: body
          }
        end
      end
    end
  end
end
