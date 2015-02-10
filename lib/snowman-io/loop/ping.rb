module SnowmanIO
  module Loop
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
        if base_url = SnowmanIO.storage.get(Storage::BASE_URL_KEY)
          open(base_url + "/login")
        end
      end
    end
  end
end
