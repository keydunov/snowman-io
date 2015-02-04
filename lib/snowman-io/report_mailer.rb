module SnowmanIO
  class ReportMailer < ActionMailer::Base
    default(
      template_path: "report_mailer",
      from: "no-reply@example.com"
    )

    def daily_report(at, report, alerts = {})
      @report = report
      @alerts = alerts
      mail(
        to: ENV["REPORT_RECIPIENTS"] || "test@example.com",
        subject: "SnowmanIO daily report at #{at.strftime("%Y-%m-%d")}"
      ) do |format|
        format.html { render :"report_mailer/daily_report" }
      end
    end
  end
end
