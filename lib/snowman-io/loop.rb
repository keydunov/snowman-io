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
      @block.call
      after(@timeout) { tick }
    end
  end
end
