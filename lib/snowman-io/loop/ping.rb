require "open-uri"

module SnowmanIO
  module Loop
    class Ping
      include Celluloid

      def initialize
        every(5*60) {ping}
      end

      def ping
        if base_url = SnowmanIO.storage.get(Storage::BASE_URL_KEY)
          open(base_url + "/login")
        end
      end
    end
  end
end
