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
        @check.cmp_fn.call(metric_value, @check.value)
      end

      private

      def metric_value
        if @metric.metric_name.blank?
          @metric.last_value
        else

          # HG metric
          # Set 20 minutes interval to be sure fetch even rare metric
          parse_value(HgAPI.get_value(
            :target => target_for_metric,
            :from   => 20.minutes.ago.to_i
          ))
        end
      end

      def target_for_metric
        if @metric.kind == "amount"
          "keepLastValue(summarize(#{@metric.metric_name}, '#{DEFAULT_METRIC_PERIOD}', 'sum', true))"
        end
      end

      def parse_value(data)
        if @metric.kind == "amount"
          data.first.try(:[], "datapoints").try(:last).try(:first).try(:to_i)
        end
      end

    end
  end
end
