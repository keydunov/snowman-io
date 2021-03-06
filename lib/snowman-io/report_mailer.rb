require 'premailer'

module SnowmanIO
  class ReportMailer < ActionMailer::Base
    default(
      template_path: "report_mailer",
      from: "no-reply@example.com"
    )
    
    def daily_report(at, report)
      @report = report
      @alerts = {}
      @at = at
      mail(
        to: SnowmanIO.report_recipients,
        subject: "SnowmanIO daily report for #{at.strftime("%Y-%m-%d")}"
      ) do |format|
        format.html { 
          Premailer.new(render(:"report_mailer/daily_report", layout: "main"), {
            css: [
              File.expand_path('../views/layouts/styles.css', __FILE__),
              File.expand_path('../views/layouts/custom.css', __FILE__)
            ],
            with_html_string: true
          }).to_inline_css
        }
      end
    end
  end
end
