module SnowmanIO
  class DataPoint
    include Mongoid::Document
    belongs_to :metric

    field :at, type: DateTime
    field :value, type: Float
  end
end
