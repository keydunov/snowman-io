module SnowmanIO
  module Utils
    def self.floor_5min(time)
      Time.new(time.year, time.month, time.day, time.hour, (time.min/5)*5)
    end

    def self.avg(arr)
      arr.inject(:+).to_f/arr.length
    end

    # Returns `t` percentile for `arr`
    def self.pct(arr, t)
      arr.sort[(t*(arr.length - 1)).round]
    end

    def self.human_value(value)
      return unless value

      if value > 1_000_000
        (value/1000000).round(1).to_s + "M"
      elsif value > 1_000
        (value/1000).round(1).to_s + "k"
      elsif value > 10
        value.round(1)
      elsif value > 0.1
        value.round(2)
      elsif value > 0.01
        value.round(3)
      elsif value > 0.001
        value.round(4)
      elsif value > 0.0001
        value.round(5)
      elsif value > 0.00001
        value.round(6)
      else
        value
      end
    end
  end
end
