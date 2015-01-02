require "bundler/gem_tasks"

namespace :dev do
  desc "run development environment (http://localhost:4200 - ember, http://localhost:4567 - web)"
  task :run do
    pids = [
      # spawn("cd demo-app && REDIS_URL=redis://localhost:6379 EMBER_DEV=1 bundle exec rerun -d ../lib snowman"),
      spawn("cd demo-app && MONGO_URL=mongodb://localhost:27017/db EMBER_DEV=1 bundle exec rerun -d ../lib 'snowman -v'"),
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
end

