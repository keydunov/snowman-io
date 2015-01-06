require "bundler/setup"
require "snowman-io"

metrics = SnowmanIO.storage.metrics_all.map { |m| m["name"] }
from = SnowmanIO::Utils.ceil_time(3.day.ago)
while from < Time.now
  metrics.each do |name|
    SnowmanIO.storage.metrics_register_value(name, rand*10_000, from)
  end
  from += 5.minutes
end
