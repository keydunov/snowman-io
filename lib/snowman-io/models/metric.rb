module SnowmanIO
  module Models
    class Metric
      def self.create(name, value, at)
        day = at.beginning_of_day.strftime("%Y-%m-%d")
        off = at.hour*12 + at.min/5
        SnowmanIO.adapter.set("metrics@#{name}@#", name)
        SnowmanIO.adapter.set("metrics@#{name}@@#{day}@#{"%03d" % off}", value)
      end

      def self.all
        SnowmanIO.adapter.keys("metrics@*@#").map { |key|
          name = key.split("@", 3)[1]
          last = SnowmanIO.adapter.keys("metrics@#{name}@@*").last
          if last
            value = SnowmanIO.adapter.get(last)
          end
          {
            id: name,
            value: value
          }
        }
      end
    end
  end
end
