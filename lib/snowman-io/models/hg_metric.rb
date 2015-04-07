module SnowmanIO
  class HgMetric
    include Mongoid::Document
    belongs_to :app

    field :name, type: String
    field :metric_name, type: String
    field :kind, type: String

    def as_json(options = {})
      super(options).tap do |o|
        o["id"]     = o.delete("_id").to_s
        o["app_id"] = o["app_id"].to_s
      end
    end
  end
end
