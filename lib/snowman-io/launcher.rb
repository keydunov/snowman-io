require 'snowman-io/scheduler'
require 'snowman-io/handler'

module SnowmanIO
  class Launcher
    include Celluloid

    attr_reader :scheduler, :handler

    def initialize(checks)
      @handler = Handler.new_link
      @scheduler = Scheduler.new_link(checks)
      @scheduler.handler = handler
    end

    def start
      scheduler.async.start
    end

    def stop
      #TODO
    end
  end
end
