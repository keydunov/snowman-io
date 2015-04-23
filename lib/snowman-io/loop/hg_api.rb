module SnowmanIO
  module Loop
    class HgAPI
      def self.get_value(params = {})
        params.merge!(format: :json)

        req = Net::HTTP::Post.new(hg_url.path)
        req.set_form_data(params)
        http = Net::HTTP.new(hg_url.host, hg_url.port)
        http.use_ssl = true
        resp = http.request(req)
        data = JSON.parse(resp.body)
      end

      def self.hg_url
        URI.parse("https://www.hostedgraphite.com#{Setting.hg_get[:hg_key]}/graphite/render")
      end
    end
  end
end
