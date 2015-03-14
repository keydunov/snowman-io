module SnowmanIO
  class Aggregation
    include Mongoid::Document
    belongs_to :metric

    field :precision, type: String
    field :at, type: DateTime
    field :count, type: Float
    field :min, type: Float
    field :avg, type: Float
    field :up, type: Float
    field :max, type: Float
    field :sum, type: Float
  end
end
