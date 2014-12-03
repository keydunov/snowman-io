module SnowmanIO
  # Processor initiated by Scheduler, executes check and notifies
  # Scheduler about the result of the check.
  class Processor
    include Celluloid

    def initialize(scheduler)
      @scheduler = scheduler
    end

    # TODO: logging can be extracted in some kind of middleware
    def process(check)
      begin
        SnowmanIO.logger.info("Processing check #{check.human}, started at #{Time.now}")
        result = check.new.perform
      rescue Exception => e
        result = result_from_exception(check, e)
        raise
      ensure
        SnowmanIO.logger.info("Processing check #{check.human}, finished at #{Time.now}")
        @scheduler.processor_done(current_actor, result)
      end
    end

    private

    def result_from_exception(check, e)
      message = "Check #{check.human} was interruppted by exception: #{e.class}: #{e.message}"
      CheckResult.new(check, "exception", message)
    end
  end
end
