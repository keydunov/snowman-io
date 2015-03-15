module SnowmanIO
  class Metric
    include Mongoid::Document
    belongs_to :app
    has_many :data_points, dependent: :destroy
    has_many :aggregations, dependent: :destroy

    field :name, type: String
    field :kind, type: String
    field :last_value, type: Float
  end
end
