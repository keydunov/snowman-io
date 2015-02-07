module SnowmanIO
  module StorageImpl
    module Reports
      def report_send(at)
        report = {apps: []}

        SnowmanIO.mongo.db["apps"].find().sort(:name).to_a.each { |app|
          json = _daily_metrics_for_app(app["_id"].to_s, at)
          report[:apps].push(json.merge(name: app["name"]))
        }

        ReportMailer.daily_report(at, report).deliver
      end

      # TODO: use this code
      # metrics = SnowmanIO.mongo.db['metrics'].find({}, { fields: ["name", "daily", "kind"] })
      # alerts = ChecksRunner.new(metrics).start
    end
  end
end
