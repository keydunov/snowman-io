require 'snowman-io/scheduler'
require 'snowman-io/handler'
require 'snowman-io/web_server'

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
      @web_server_supervisor = WebServer.supervise_as(:web_server, API, @options)
      scheduler.async.schedule_checks
    end

    def stop
      handler.terminate if handler.alive?
      scheduler.async.stop(@options[:timeout])
      @finished_condition.wait
      @web_server_supervisor.terminate # TODO: shutdown blocking?
      scheduler.terminate
    end
  end
end
