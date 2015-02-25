module SnowmanIO
  class User
    include MongoMapper::Document
    include ActiveModel::SecurePassword

    has_secure_password

    key :email,                String
    key :password_digest,      String
    key :authentication_token, String

    validates :email, :authentication_token, presence: true

    before_validation on: :create do
      self.authentication_token = generate_token(:authentication_token)
    end

    private

    def generate_token(token)
      loop do
        token = SecureRandom.hex
        break token unless self.class.where(token: token).first
      end
    end
  end
end
