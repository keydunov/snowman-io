module SnowmanIO
  class Metric
    SOURCE_SNOWMAN = "snowman"
    SOURCE_HG = "hg"

    include Mongoid::Document
    belongs_to :app
    has_many :checks, dependent: :destroy

    field :name, type: String
    field :source, type: String
    field :kind, type: String

    # source: snowman
    has_many :data_points, dependent: :destroy
    has_many :aggregations, dependent: :destroy
    field :last_value, type: Float

    # source: hg
    field :metric_name, type: String

    def as_json(options = {})
      super(options.merge(methods: [:check_ids])).tap do |o|
        o["id"]     = o.delete("_id").to_s
        o["app_id"] = o["app_id"].to_s
        o["check_ids"] = o["check_ids"].map(&:to_s)
      end
    end
  end
end
