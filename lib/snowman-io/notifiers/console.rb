module SnowmanIO
  module Notifiers
    class Console < Base
      class << self
        def configured?
          true
        end
      end

      private

      def post_data(subject, body)
        SnowmanIO.logger.info "\nNotify fired: #{subject}\n----\n#{body}"
      end
    end
  end
end
