module SnowmanIO
  module Notifiers
    class Slack < Base
      class << self
        def webhook_url
          ENV["SLACK_WEBHOOK_URL"]
        end

        def channel
          ENV["SLACK_CHANNEL"]
        end

        def bot_name
          ENV["SLACK_BOT_NAME"]
        end

        def configured?
          webhook_url.present?
        end
      end

      protected

      def configuration
        {
          :webhook_url => self.class.webhook_url,
          :bot_name => self.class.bot_name || "snowman-io",
          :channel => self.class.channel
        }
      end

      def post_data(subject, message)
        uri = URI(configuration[:webhook_url])
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        req = Net::HTTP::Post.new("#{uri.path}?#{uri.query}")
        req.body = payload(message).to_json

        response = http.request(req)
        verify_response(response)
      end

      def slack_uri(token)
        url = "https://#{team_name}.slack.com/services/hooks/incoming-webhook?token=#{token}"
        URI(url)
      end

      def verify_response(response)
        case response
        when Net::HTTPSuccess
          true
        else
          raise response.error!
        end
      end

      # TODO: include :icon_url
      def payload(text)
        {
          :username    => configuration[:bot_name],
          :attachments => [{
            :text  => text,
            :color => "#FF0000"
          }]
        }.tap { |payload| payload[:channel] = channel if configuration[:channel] }
      end
    end
  end
end
