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

      @main = Loop.supervise_as(:main, 3) {
        now = Time.now
        next_report_date = Time.now.beginning_of_day

        # aggregate
        start = Time.now.to_f
        SnowmanIO.storage.metrics_aggregate_5min
        SnowmanIO.storage.metrics_aggregate_daily
        SnowmanIO.storage.metrics_clean_old

        unless SnowmanIO.storage.get(Storage::NEXT_REPORT_DATE)
          SnowmanIO.storage.set(Storage::NEXT_REPORT_DATE, next_report_date.to_i)
        end

        # send report at 7:00
        if now.to_i > SnowmanIO.storage.get(Storage::NEXT_REPORT_DATE) + 1.day + 7.hours
          SnowmanIO.storage.report_send(Time.at(SnowmanIO.storage.get(Storage::NEXT_REPORT_DATE)))
          SnowmanIO.storage.set(Storage::NEXT_REPORT_DATE, next_report_date.to_i)
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
