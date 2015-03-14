module SnowmanIO
  class User
    include Mongoid::Document
    include ActiveModel::SecurePassword
    include Concerns::Tokenable

    has_secure_password

    field :email,                type: String
    field :password_digest,      type: String
    field :authentication_token, type: String

    validates :email, :authentication_token, presence: true
    validates :email, uniqueness: true

    before_validation on: :create do
      self.authentication_token = generate_token(:authentication_token)
    end
  end
end
