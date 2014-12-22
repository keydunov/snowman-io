module SnowmanIO
  # Handler process result from checks, saves them
  # to redis and fires notifications if needed.
  class Handler
    include Celluloid

    def handle(result)
      history_key = "history:#{result.check_name.underscore}"
      fail_count_key = "checks:#{result.check_name.underscore}:fail_count"
      SnowmanIO.redis.rpush(history_key, result.serialize)
      history = SnowmanIO.redis.lrange(history_key, -4, -1).map { |result| JSON.load(result) }

      if result.status == 'failed' || result.status == 'exception'
        if SnowmanIO.redis.incr(fail_count_key) == 1
          notify_fail(result)
        end
      end
    end

    private

    def notify_fail(result)
      result.check.notifiers.each { |notifier| notifier.pool.async.notify(result) }
    end
  end
end
