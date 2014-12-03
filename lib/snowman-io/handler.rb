module SnowmanIO
  # Handler process result from checks, saves them
  # to redis and fires notifications if needed.
  class Handler
    include Celluloid

    def handle(result)
      history_key = "history:#{result.check_name.underscore}"
      SnowmanIO.redis.rpush(history_key, result.serialize)
      history = SnowmanIO.redis.lrange(history_key, -4, -1).map { |result| JSON.load(result) }
      previous_status_failed = if history.size < 4
        false
      else
        ["failed", "exception"].include?(history.shift["status"])
      end
      if !previous_status_failed && history.size >= 3 && history.all? { |result| result["status"] == "failed" || result["status"] == "exception" }
        notify_fail(result)
      end
    end

    private

    def notify_fail(result)
      result.check.notifiers.each { |notifier| notifier.pool.async.notify(result) }
    end
  end
end
