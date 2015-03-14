module SnowmanIO
  class App
    include Mongoid::Document
    include Concerns::Tokenable
    has_many :metrics

    field :name,  type: String
    field :token, type: String

    validates :name, :token, presence: true

    before_validation on: :create do
      self.token = generate_token(:token)
    end

    def as_json(options = {})
      super(options.merge(methods: :requestsJSON)).tap { |o| o["id"] = o.delete("_id").to_s }
    end

    def requestsJSON
      SnowmanIO.storage.daily_metrics_for_app(self, Time.now).to_json
    end
  end
end
