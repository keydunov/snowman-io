module SnowmanIO
  module Models
    class Collector
      def self.all
        SnowmanIO.mongo.keys("collectors@*").map { |key|
          SnowmanIO.mongo.get(key)
        }
      end

      def self.find(id)
        SnowmanIO.mongo.get("collectors@#{id}")
      end

      def self.create(options)
        update(SnowmanIO.mongo.incr(API::GLOBAL_ID_KEY), options)
      end

      def self.update(id, options)
        collector = options.slice("kind", "hgMetric").merge("id" => id)
        SnowmanIO.mongo.set("collectors@#{id}", collector)
        {collector: collector}
      end

      def self.destroy(id)
        SnowmanIO.mongo.unset("collectors@#{id}")
        {collectors: {id: id}}
      end
    end
  end
end
