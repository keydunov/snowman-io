module SnowmanIO
  class App
    include MongoMapper::Document
    include Concerns::Tokenable

    key :name,  String
    key :token, String

    validates :name, :token, presence: true

    before_validation on: :create do
      self.token = generate_token(:token)
    end

    def as_json(options = {})
      super(options.merge(methods: :requestsJSON))
    end

    def requestsJSON
      SnowmanIO.storage.send(:_daily_metrics_for_app, self.id.to_s, Time.now).to_json
    end
  end
end
