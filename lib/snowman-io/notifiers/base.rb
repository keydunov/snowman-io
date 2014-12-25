module SnowmanIO
  module Notifiers
    class Base
      include Celluloid

      class << self
        def configured?
          raise "Implement #configured? in child class please"
        end
      end

      def notify(result)
        return unless self.class.configured?
        post_data(message_subject(result), message_body(result))
      end

      protected

      def message_subject(result)
        "#{result.check_name} failed - #{Time.now}"
      end

      def message_body(result)
        result.message + "\n" + SnowmanIO.store.base_url + "/checks/" + result.check_name
      end

      def post_data(subject, body)
        raise "Implement #post_data in child class please"
      end
    end
  end
end
