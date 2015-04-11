module SnowmanIO
  module API
    class Info < Grape::API
      before(&:authenticate!)

      get "info" do
        {
          base_url: Setting.get(SnowmanIO::BASE_URL_KEY),
          version: SnowmanIO::VERSION,
          report_recipients: SnowmanIO.report_recipients.join(", "),
        }.merge(Setting.hg_get)
      end

      params do
        requires :hg_status, type: String
        requires :hg_key, type: String
      end
      post "hg" do
        Setting.hg_set(permitted_params)
      end
    end
  end
end
