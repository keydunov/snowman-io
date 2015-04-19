module SnowmanIO
  class Check
    include Mongoid::Document
    belongs_to :metric

    field :cmp, type: String
    field :value, type: Float

    def as_json(options = {})
      super(options).tap do |o|
        o["id"] = o.delete("_id").to_s
        o["metric_id"] = o["metric_id"].to_s
      end
    end
  end
end
