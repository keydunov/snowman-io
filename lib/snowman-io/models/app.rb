module SnowmanIO
  class App
    include Mongoid::Document
    include Concerns::Tokenable
    has_many :metrics, dependent: :destroy
    has_many :hg_metrics, dependent: :destroy

    field :name,  type: String
    field :token, type: String

    validates :name, :token, presence: true

    before_validation on: :create do
      self.token = generate_token(:token)
    end

    def as_json(options = {})
      super(options.merge(methods: [:requestsJSON, :hgMetrics])).tap { |o| o["id"] = o.delete("_id").to_s }
    end

    # Returns amount of requests for `at` and day before
    def daily_metrics(at)
      json = {}
      metric = metrics.where(kind: "request").first

      today = at.beginning_of_day
      yesterday = at.beginning_of_day - 1.day
      json["today"] = {"at" => today.strftime("%Y-%m-%d")}
      json["yesterday"] = {"at" => yesterday.strftime("%Y-%m-%d")}

      if metric && (aggr = metric.aggregations.where(precision: "daily", at: today).first)
        json["today"]["count"] =  aggr.count.to_i
      end

      if metric && (aggr = metric.aggregations.where(precision: "daily", at: yesterday).first)
        json["yesterday"]["count"] = aggr.count.to_i
      end

      if metric
        json["total"] = {"count" => metric.aggregations.where(precision: "daily").sum(:count).to_i}
      end

      json
    end

    def register_metric_value(name, kind, value, at)
      metric = metrics.where(name: name, kind: kind).first_or_create!
      metric.update_attributes!(last_value: value)
      metric.data_points.create!(at: at, value: value)
    end

    def requestsJSON
      daily_metrics(Time.now).to_json
    end

    def hgMetrics
      hg_metrics.map { |m| {id: m._id.to_s} }
    end
  end
end
