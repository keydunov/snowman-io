module SnowmanIO
  # Runs checks against daily metrics.
  class ChecksRunner
    def initialize
    end

    def start
      metrics.each_with_object({}) do |metric, hash|
        hash[metric['name']] = checks_for(metric).compact
      end.reject { |k,v| v.empty? }
    end

    private

    # Runs various checks for metric and return array of checks results
    # Check result can be either instance of alert class or nil
    def checks_for(metric)
      [IncreasedCheck.new(metric).run]
    end

    # TODO: find({ system: true }, ...)
    def metrics
      SnowmanIO.mongo.db['metrics'].find({}, { fields: ["name", "daily", "kind"] })
    end

  end

  class Check
    def initialize(metric)
      @metric = metric
      # double check to be sure it is sorted by keys (timestamps)
      # Do we need it?
      @metric['daily'] = @metric['daily'].sort.to_h
    end

    # Returns alert or nil
    def run
      check if checkable?
    end

    private

    def check
      raise NotImplementedError
    end

    # Filter if check actually can be done against current metric
    # We cannot check anythig if we do not have at least two days to compare
    # TODO: not sure what criterias are for metric to be checkable
    def checkable?
      @metric['daily'].size > 1 &&
      @metric['daily'].values.last['count'] > 0
    end
  end

  Alert = Struct.new(:metric_name, :check, :message)

  # Check if current value has increased
  # significantly compared to first value
  class IncreasedCheck < Check
    def check
      if today_avg > first_avg
        Alert.new(@metric['name'], self.class.name, message)
      end
    end

    def today_avg
      @metric['daily'].values.last['avg']
    end

    def first_avg
      @metric['daily'].values.first['avg']
    end

    def message
      "Today's #{@metric['name']} (#{human(today_avg)}) has increased compared to the (date of first collected metric) (#{human(first_avg)}) "
    end

    def human(val)
      Utils.human_value(val)
    end
  end

  class RequestCheck < Check
  end

  class CheckResult; end
end
