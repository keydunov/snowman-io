module SnowmanIO
  # Handler process result from checks, saves them
  # to redis and fires notifications if needed.
  class Handler
    include Celluloid

    def handle(result)
      failed = (result.status == 'failed' || result.status == 'exception')
      SnowmanIO.store.save_last_check(result.check_name, result.context)
      if SnowmanIO.store.check_on_handle(result.check_name, failed) == :failed
        SnowmanIO.store.mark_check_as_failed(result.check_name)
        notify_fail(result)
      end
    end

    private

    def notify_fail(result)
      result.check.notifiers.each { |notifier| notifier.pool.async.notify(result) }
    end
  end
end
