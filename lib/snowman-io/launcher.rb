require 'snowman-io/scheduler'
require 'snowman-io/handler'

module SnowmanIO
  class Launcher
    include Celluloid

    attr_reader :scheduler, :handler

    def initialize(options)
      @finished_condition = Celluloid::Condition.new
      @handler = Handler.new_link
      @scheduler = Scheduler.new_link(@finished_condition, options[:checks])
      @scheduler.handler = handler
      @options = options
    end

    def start
      scheduler.async.schedule_checks
    end

    def stop
      handler.terminate if handler.alive?
      scheduler.async.stop(@options[:timeout])
      @finished_condition.wait
      scheduler.terminate
    end
  end
end
