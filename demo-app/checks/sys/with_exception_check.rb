module Sys
  class WithExceptionCheck < SnowmanIO::Check
    interval 5.seconds

    def ok?
      raise "x"
    end
  end
end
