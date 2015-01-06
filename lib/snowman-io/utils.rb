module SnowmanIO
  module Utils
    def self.date_to_key(at)
      day = at.beginning_of_day.strftime("%y%m%d")
      off = "%03d" % (at.hour*12 + at.min/5)
      (day + off).to_i
    end

    def self.ceil_time(time)
      seconds = 5*60
      Time.at((time.to_f/seconds).ceil*seconds)
    end

    def self.floor_time(time)
      seconds = 5*60
      Time.at((time.to_f/seconds).floor*seconds)
    end
  end
end
