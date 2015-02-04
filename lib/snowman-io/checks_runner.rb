module SnowmanIO
  # Runs checks against daily metrics.
  class ChecksRunner
    def initialize(metrics)
      @metrics = metrics
    end

    def start
      @metrics.each_with_object({}) do |metric, hash|
        hash[metric['name']] = run_checks_for(metric).compact
      end.reject { |k,v| v.empty? }
    end

    private

    # Runs various checks for metric and return array of checks results
    # Check result can be either instance of alert class or nil
    def run_checks_for(metric)
      results = [IncreasedCheck.new(metric).run]
      if metric['kind'] == 'request'
        results << RequestCheck.new(metric).run
      end
      results
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

    def human(val)
      Utils.human_value(val)
    end
  end

  Alert = Struct.new(:metric_name, :check, :message)

  # Check if current value has increased
  # significantly compared to first value
  class IncreasedCheck < Check
    def check
      if today_avg > first_avg*2
        Alert.new(@metric['name'], self.class.name, message)
      end
    end

    def today_avg
      @metric['daily'].values.last['avg']
    end

    def first_avg
      @metric['daily'].values.first['avg']
    end

    def first_date
      DateTime.strptime(@metric['daily'].keys.first,'%s').strftime('%B %d, %y')
    end

    def message
      "Today's #{@metric['name']} (#{human(today_avg)}) has increased compared to the #{first_date} (#{human(first_avg)}) "
    end
  end

  class RequestCheck < Check
    def check
      if today_avg > 1000
        Alert.new(@metric['name'], self.class.name, message)
      end
    end

    def today_avg
      @metric['daily'].values.last['avg']
    end

    def message
      "Today's #{@metric['name']} average (#{human(today_avg)}) is bigger than 1 sec."
    end

    def human(val)
      Utils.human_value(val)
    end
  end

  class CheckResult; end
end
