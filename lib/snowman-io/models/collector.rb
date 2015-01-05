module SnowmanIO
  module Models
    class Collector
      def self.all
        SnowmanIO.adapter.keys("collectors@*").map do |key|
          SnowmanIO.adapter.get(key)
        end
      end

      def self.find(id)
        SnowmanIO.adapter.get("collectors@#{id}")
      end

      def self.create(options)
        update(SnowmanIO.adapter.incr(API::GLOBAL_ID_KEY), options)
      end

      def self.update(id, options)
        errors = errors_for(options)
        if errors.empty?
          collector = craft(options, id)
          SnowmanIO.adapter.set("collectors@#{id}", collector)
          {status: :ok, collector: collector}
        else
          {status: :failed, errors: errors}
        end
      end

      private

      def self.craft(options, id)
        options.slice("kind", "hgMetric").merge("id" => id)
      end

      def self.errors_for(options)
        errors = {}
        if options["kind"] == "HG"
          unless options["hgMetric"].present?
            errors["hgMetric"] ||= []
            errors["hgMetric"].push("HG Metric should not be empty")
          end
        else
          raise "I dont know how to work with collector kind #{options["kind"]}"
        end
        errors
      end
    end
  end
end
