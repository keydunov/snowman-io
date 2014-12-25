module Sys
  class SysCheck < SnowmanIO::Check
    interval 5.seconds

    def ok?
      [false, true].sample
    end
  end
end
