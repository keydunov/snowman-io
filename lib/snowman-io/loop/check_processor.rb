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

        metric_value = parse_value(HgAPI.get_value(
                        :target => target_for_metric,
                        :from   => 20.minutes.ago.to_i
                       ))

        @check.cmp_fn.call(metric_value, @check.value)
      end

      private

      def target_for_metric
        if @metric.kind == "amount"
          "keepLastValue(summarize(#{@metric.metric_name}, '#{DEFAULT_METRIC_PERIOD}', 'sum', true))"
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
