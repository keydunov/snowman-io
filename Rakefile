require "bundler/gem_tasks"

ENV["DEV_MODE"] = "1"
require "snowman-io"

namespace :dev do
  desc "run development environment (http://localhost:4200 - ember, http://localhost:4567 - web)"
  task :run do
    pids = [
      spawn("cd demo-app && DEV_MODE=1 rerun -d ../lib 'bundle exec snowman -v'"),
      spawn("cd ui && ./node_modules/.bin/ember server --proxy http://localhost:4567"),
    ]

    trap "INT" do
      Process.kill "INT", *pids
      exit 1
    end

    loop do
      sleep 1
    end
  end

  desc "Aggregate 5min metrics"
  task :aggregate_5min do
    SnowmanIO.storage.metrics_aggregate_5min
  end

  desc "Aggregate daily metrics"
  task :aggregate_daily do
    SnowmanIO.storage.metrics_aggregate_daily
  end

  desc "Clean old metrics"
  task :clean_old do
    SnowmanIO.storage.metrics_clean_old
  end

  desc "Send report"
  task :report_send do
    SnowmanIO.storage.report_send(Time.now.beginning_of_day)
  end

  desc "Run checks on metrics"
  task :alerts do
    metrics = SnowmanIO.mongo.db['metrics'].find({}, { fields: ["name", "daily", "kind"] })
    puts SnowmanIO::ChecksRunner.new(metrics).start
  end
end

