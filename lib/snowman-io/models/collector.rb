module SnowmanIO
  module Models
    class Collector
      def self.all
        SnowmanIO.adapter.keys("collectors@*").map { |key|
          SnowmanIO.adapter.get(key)
        }
      end

      def self.find(id)
        SnowmanIO.adapter.get("collectors@#{id}")
      end

      def self.create(options)
        update(SnowmanIO.adapter.incr(API::GLOBAL_ID_KEY), options)
      end

      def self.update(id, options)
        collector = options.slice("kind", "hgMetric").merge("id" => id)
        SnowmanIO.adapter.set("collectors@#{id}", collector)
        {collector: collector}
      end

      def self.destroy(id)
        SnowmanIO.adapter.unset("collectors@#{id}")
        {collectors: {id: id}}
      end
    end
  end
end
