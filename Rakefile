require "bundler/gem_tasks"

namespace :dev do
  task :run do
    pids = [
      spawn("cd demo-app && EMBER_DEV=1 bundle exec snowman"),
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

