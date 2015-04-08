module SnowmanIO
  module Utils
    def self.floor_5min(time)
      Time.new(time.year, time.month, time.day, time.hour, (time.min/5)*5)
    end

    def self.avg(arr)
      arr.inject(:+).to_f/arr.length
    end

    # `up` value is close to 90 percentile by meaning, but it slightly
    # depends of every element (weighted avarage). This metric is especially usefull for small arrays.
    def self.up(arr)
      sorted = arr.sort
      if sorted.length <= 1
        sorted[0]
      else
        sum = 0
        amount = 0
        sorted.each_with_index { |e, i|
          w = i.to_f/sorted.length
          if w <= 0.9
            a = w + 0.1
          else
            a = 1.9 - w
          end
          sum += e*a
          amount += a
        }
        sum/amount
      end
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
