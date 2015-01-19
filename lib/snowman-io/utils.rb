module SnowmanIO
  module Utils
    def self.floor_5min(time)
      Time.new(time.year, time.month, time.day, time.hour, (time.min/5)*5)
    end

    def self.floor_20sec(time)
      Time.new(time.year, time.month, time.day, time.hour, time.min, (time.sec/20)*20)
    end

    def self.avg(arr)
      arr.inject(:+).to_f/arr.length
    end

    def self.pct(arr, t)
      arr.sort[(t*(arr.length - 1)).round]
    end
  end
end
