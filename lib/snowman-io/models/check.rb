module SnowmanIO
  class Check
    include Mongoid::Document
    belongs_to :hg_metric

    field :cmp, type: String
    field :value, type: Float
  end
end
