module SnowmanIO
  class HgMetric
    include Mongoid::Document
    belongs_to :app

    field :name, type: String
    field :metricName, type: String
    field :kind, type: String
  end
end
