module SnowmanIO
  class Check
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    belongs_to :metric

    field :cmp, type: String
    field :value, type: Float

    field :triggered, type: Boolean, default: false
    field :last_run_at, type: DateTime

    scope :active, -> { where(triggered: false) }

    def as_json(options = {})
      super(options).tap do |o|
        o["id"] = o.delete("_id").to_s
        o["metric_id"] = o["metric_id"].to_s
      end
    end

    def cmp_fn
      case cmp
      when "more"
        -> (a, b) { a > b }
      when "less"
        -> (a, b) { a < b }
      else
        raise "unreachable"
      end
    end
  end
end
