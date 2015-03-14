module SnowmanIO
  module StorageImpl
    module Reports
      def report_send(at)
        report = {apps: []}

        App.order_by(:name => :desc).each do |app|
          json = daily_metrics_for_app(app, at)
          report[:apps].push(json.merge(name: app.name))
        end

        ReportMailer.daily_report(at, report).deliver
      end
    end
  end
end
