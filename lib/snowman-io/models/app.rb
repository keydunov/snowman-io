module SnowmanIO
  class App
    include Mongoid::Document
    include Concerns::Tokenable
    has_many :metrics, dependent: :destroy

    field :name,  type: String
    field :token, type: String

    validates :name, :token, presence: true

    before_validation on: :create do
      self.token = generate_token(:token)
    end

    def as_json(options = {})
      super(options.merge(methods: [:requestsJSON, :metric_ids])).tap do |o|
        o["id"] = o.delete("_id").to_s
        o["metric_ids"] = o["metric_ids"].map(&:to_s)
      end
    end

    # Returns amount of requests for `at` and day before
    def daily_metrics(at)
      json = {}
      metric = metrics.where(kind: "request").first

      today = at.beginning_of_day
      yesterday = at.beginning_of_day - 1.day
      json["today"] = {"at" => today.strftime("%Y-%m-%d"), "count" => 0}
      json["yesterday"] = {"at" => yesterday.strftime("%Y-%m-%d"), "count" => 0}
      json["total"] = {"count" => 0}

      if metric && (aggr = metric.aggregations.where(precision: "daily", at: today).first)
        json["today"]["count"] =  aggr.count.to_i
      end

      if metric && (aggr = metric.aggregations.where(precision: "daily", at: yesterday).first)
        json["yesterday"]["count"] = aggr.count.to_i
      end

      if metric
        json["total"]["count"] = metric.aggregations.where(precision: "daily").sum(:count).to_i
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
  end
end
