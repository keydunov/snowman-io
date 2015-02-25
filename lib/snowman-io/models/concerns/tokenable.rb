module SnowmanIO
  module Concerns
    module Tokenable
      extend ActiveSupport::Concern

      def generate_token(token)
        loop do
          token = SecureRandom.hex
          break token unless self.class.where(token: token).first
        end
      end
    end
  end
end

