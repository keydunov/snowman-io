require "snowman-io/processor"

module SnowmanIO
  # Scheduler schedules execution of checks.
  class Scheduler
    include Celluloid
    trap_exit :processor_died

    attr_accessor :handler

    def initialize(finished_condition, checks)
      @finished = finished_condition
      @time = {}
      @in_progress = []
      checks.each do |check|
        @time[check] = Time.now + check.interval
      end
    end

    def schedule_checks
      return if stopped?

      @time.each do |check, time|
        if time <= Time.now
          assign_processing(check)
          @time[check] = Time.now + check.interval
        end
      end

      after(1) { schedule_checks }
    end

    def assign_processing(check)
      processor = Processor.new_link(current_actor)
      @in_progress << processor
      processor.async.process(check)
    end

    def processor_done(processor, result)
      @in_progress.delete(processor)
      @handler.async.handle(result) unless stopped?
      processor.terminate if processor.alive?
    end

    def stop(timeout)
      SnowmanIO.logger.info { "Stopping scheduling new checks" }
      @done = true
      if @in_progress.any?
        hard_shutdown_in(timeout)
      else
        @finished.signal
      end
    end

    def stopped?
      @done
    end

    def hard_shutdown_in(timeout)
      SnowmanIO.logger.info { "Pausing up to #{timeout} seconds to allow checks to finish..." }
      after(timeout) do
        SnowmanIO.logger.warn { "Terminating #{@in_progress.size} running checks" }

        @in_progress.each do |processor|
          Celluloid::Actor.kill(processor) if processor.alive?
        end

        @finished.signal
      end
    end

    def processor_died(_actor, _reason)
      # TODO
    end
  end
end
