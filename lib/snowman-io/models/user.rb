module SnowmanIO
  class User
    include MongoMapper::Document
    include ActiveModel::SecurePassword
    include Concerns::Tokenable

    has_secure_password

    key :email,                String
    key :password_digest,      String
    key :authentication_token, String

    validates :email, :authentication_token, presence: true
    validates :email, uniqueness: true

    before_validation on: :create do
      self.authentication_token = generate_token(:authentication_token)
    end
  end
end
