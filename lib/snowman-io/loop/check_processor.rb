require 'snowman-io/loop/hg_api'

module SnowmanIO
  module Loop
    class CheckProcessor
      DEFAULT_METRIC_PERIOD = "1min"

      def initialize(check)
        @check  = check
        @metric = check.metric
      end

      def process
        support_hg_only!

        metric_value = parse_value(HgAPI.get_value(target_for_metric, DEFAULT_METRIC_PERIOD))

        @check.cmp_fn.call(metric_value, @check.value)
      end

      private

      def target_for_metric
        if @metric.kind == "amount"
          "summarize(#{@metric.metric_name}, '#{DEFAULT_METRIC_PERIOD}')"
        end
      end

      def parse_value(data)
        if @metric.kind == "amount"
          data.first["datapoints"].first.first.to_i
        end
      end

      def support_hg_only!
        if @metric.metric_name.blank?
          raise "CheckProcessor supports only hg metric"
        end
      end
    end
  end
end
