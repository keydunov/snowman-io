module SnowmanIO
  module Notifiers
    class Mail
      include Celluloid

      class << self
        def mail_from
          ENV["MAIL_FROM"] || "notify@snowman.io"
        end

        def mail_to
          ENV["MAIL_TO"]
        end

        def base_url
          "https://api.mailgun.net/v2/" + ENV["MAILGUN_SMTP_LOGIN"].to_s.sub(/^postmaster@/, "")
        end

        def api_key
          ENV["MAILGUN_API_KEY"]
        end

        def configured?
          api_key.present? && mail_to.present?
        end
      end

      def notify(result)
        return unless self.class.configured?
        post_data(result.message)
      end

      private

      def post_data(message)
        `curl -s --user 'api:#{self.class.api_key}' \
          #{self.class.base_url}/messages \
          -F from='#{self.class.mail_from}' \
          -F to='#{self.class.mail_to}' \
          -F subject='Check failed' \
          -F text='#{message}'`
      end
    end
  end
end
