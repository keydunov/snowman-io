module SnowmanIO
  module Reports
    def self.report_send(at)
      report = {apps: []}

      App.order_by(:name => :asc).each do |app|
        json = app.daily_metrics(at)
        report[:apps].push(json.merge(name: app.name))
      end

      ReportMailer.daily_report(at, report).deliver
    end
  end
end
