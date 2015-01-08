require "bundler/gem_tasks"

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
end

