module SnowmanIO
  module Loop
    # Ping itself every 5 minutes to be in fit
    class Ping
      include Celluloid

      def initialize
        after(10) { tick }
      end

      def tick
        perform
        after(5*60) { tick }
      end

      private

      def perform
        if base_url = Setting.get(SnowmanIO::BASE_URL_KEY)
          open(base_url + "/ping")
        end
      end
    end
  end
end
