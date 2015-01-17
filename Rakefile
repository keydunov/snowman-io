require "bundler/gem_tasks"

ENV["DEV_MODE"] = "1"
require "snowman-io"

namespace :dev do
  desc "run development environment (http://localhost:4200 - ember, http://localhost:4567 - web)"
  task :run do
    pids = [
      spawn("cd demo-app && DEV_MODE=1 rerun -d ../lib 'bundle exec snowman -v'"),
      spawn("cd ui && ./node_modules/.bin/ember server"),
    ]

    trap "INT" do
      Process.kill "INT", *pids
      exit 1
    end

    loop do
      sleep 1
    end
  end

  desc "Generate random value for test metric"
  task :random do
    SnowmanIO.storage.metrics_register_value("Test", rand)
  end

  desc "Aggregate 5min metrics"
  task :aggregate_5min do
    SnowmanIO.storage.metrics_aggregate_5min
  end

  desc "Aggregate daily metrics"
  task :aggregate_daily do
    SnowmanIO.storage.metrics_aggregate_daily
  end

  desc "Generate report"
  task :report_gen do
    SnowmanIO.storage.reports_generate_once((Time.now - 1.day).beginning_of_day)
  end

  desc "Send report"
  task :report_send do
    SnowmanIO.storage.reports_send_once((Time.now - 1.day).beginning_of_day)
  end
end

