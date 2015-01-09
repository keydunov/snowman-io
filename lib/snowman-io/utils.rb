module SnowmanIO
  module Utils
    def self.date_to_key(at)
      day = at.beginning_of_day.strftime("%y%m%d")
      off = "%03d" % (at.hour*12 + at.min/5)
      (day + off).to_i
    end

    def self.key_to_date(key)
      min = ((key % 1000 ) % 12) * 5
      hour = (key % 1000 ) / 12
      day = (key / 1000) % 100
      month = (key / 100000) % 100
      year = 2000 + (key / 10000000)
      Time.new(year, month, day, hour, min)
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
