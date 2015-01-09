require "bundler/gem_tasks"
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

  desc "Fill test metric with test values for last month"
  task :test_metric do
    at = Time.now.beginning_of_day
    288.times {
      SnowmanIO.storage.metrics_register_value("test", rand*100, at)
      at += 5.minutes
    }
    at = Time.now.beginning_of_day - 1.day
    30.times {
      # TODO: move this code into storage
      metric = SnowmanIO.mongo.db["metrics"].find(name: "test").first
      key = SnowmanIO::Utils.date_to_key(at)
      avg = rand*100
      SnowmanIO.mongo.db["daily"].update(
        {key: key},
        {"$set" => {
          key: key,
          "#{metric["id"]}.max" => avg*(1 + rand*0.3),
          "#{metric["id"]}.min" => avg*(1 - rand*0.3),
          "#{metric["id"]}.avg" => avg
        }},
        upsert: true
      )
      at -= 1.day
    }
  end
end

