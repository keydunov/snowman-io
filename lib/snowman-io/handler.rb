module SnowmanIO
  # Handler process result from checks, saves them
  # to redis and fires notifications if needed.
  class Handler
    include Celluloid

    def handle(result)
      SnowmanIO.store.add_history_check(result.check_name.underscore, result)

      if result.status == 'failed' || result.status == 'exception'
        if SnowmanIO.store.on_fail_check(result.check_name.underscore) == 1
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
