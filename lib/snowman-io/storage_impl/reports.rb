module SnowmanIO
  module StorageImpl
    module Reports
      def report_send(at)
        report = {apps: []}
        SnowmanIO.mongo.db["apps"].find().sort(:name).to_a.each { |app|
          report[:apps].push(name: app["name"])
        }
        ReportMailer.daily_report(at, report).deliver
      end

      # def reports_send_once(report_for)
      #   key = report_for.to_i
      #   report = reports_find_by_key(key)
      #   metrics = SnowmanIO.mongo.db['metrics'].find({}, { fields: ["name", "daily", "kind"] })
      #   alerts = ChecksRunner.new(metrics).start
      #   return if !report || report["sended"]
      #   ReportMailer.daily_report(report_for, JSON.load(report["report"]), alerts).deliver
      #   SnowmanIO.mongo.db["reports"].update(
      #     {key: key},
      #     {"$set" => {"sended" => true}}
      #   )
      # end
    end
  end
end
