require "open-uri"

module SnowmanIO
  # Execute block after `timeout` seconds periodic
  class Loop
    include Celluloid

    def initialize(timeout, &block)
      @timeout = timeout
      @block = block
      async.tick
    end

    def tick
    end
  end
end
