module SnowmanIO
  class Check
    include Mongoid::Document
    belongs_to :hg_metric

    field :cmp, type: String
    field :value, type: Float

    def as_json(options = {})
      super(options).tap do |o|
        o["id"] = o.delete("_id").to_s
        o["hg_metric_id"] = o["hg_metric_id"].to_s
      end
    end
  end
end
