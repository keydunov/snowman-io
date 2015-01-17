require "open-uri"

module SnowmanIO
  class Launcher
    include Celluloid

    def initialize(options)
      @options = options
    end

    def start
      @web_server_supervisor = WebServer.supervise_as(:web_server, API, @options.slice(:port, :host, :verbose))

      # self ping to be in fit
      @ping = Loop.supervise_as(:ping, 5*60) {
        if base_url = SnowmanIO.storage.get(Storage::BASE_URL_KEY)
          open(base_url + "/login")
        end
      }

      @main = Loop.supervise_as(:main, 10) {
        now = Time.now
        report_for = (now - 1.day).beginning_of_day

        # aggregate
        SnowmanIO.storage.metrics_aggregate_5min
        SnowmanIO.storage.metrics_aggregate_daily
        SnowmanIO.storage.metrics_clean_old_daily

        # generate report (from 1:00 till 6:00) to be sure all daily metrics aggregated
        if 1 < now.hour && now.hour < 6
          SnowmanIO.storage.reports_generate_once(report_for)
        end

        # Send report after 7:00
        if now.hour > 7
          SnowmanIO.storage.reports_send_once(report_for)
        end
      }
    end

    def stop
      @main.terminate
      @ping.terminate
      @web_server_supervisor.terminate # TODO: shutdown blocking?
    end
  end
end
