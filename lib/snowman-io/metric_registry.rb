module SnowmanIO
  # Use separate actor because Storage#metrics_find_or_create is not threadsafe
  class MetricRegistry
    include Celluloid

    def get_metric(name)
      SnowmanIO.storage.metrics_find_or_create(name)
    end
  end
end
