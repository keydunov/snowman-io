require "snowman-io/processor"

module SnowmanIO
  # Scheduler schedules execution of checks.
  class Scheduler
    include Celluloid
    trap_exit :processor_died

    attr_accessor :handler

    def initialize(checks)
      @time = {}
      checks.each do |check|
        @time[check] = Time.now + check.interval
      end
    end

    def start
      every(1) { schedule_checks }
    end

    def processor_done(processor, result)
      @handler.async.handle(result)
      processor.terminate
    end

    private

    def schedule_checks
      @time.each do |check, time|
        if time <= Time.now
          Processor.new_link(current_actor).async.process(check)
          @time[check] = Time.now + check.interval
        end
      end
    end

    def processor_died(_actor, _reason)
      # TODO
    end
  end
end
