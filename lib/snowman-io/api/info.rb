module SnowmanIO
  module API
    class Info < Grape::API
      before(&:authenticate!)

      get "info" do
        {
          base_url: SnowmanIO.storage.get(Storage::BASE_URL_KEY),
          version: SnowmanIO::VERSION,
          report_recipients: SnowmanIO.report_recipients
        }
      end
    end
  end
end
