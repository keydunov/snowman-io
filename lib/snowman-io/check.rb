module SnowmanIO
  class Check
    Alert = Struct.new(:metric_name, :check, :message)

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

    def today_avg
      @metric['daily'].values.last['avg']
    end

    def first_avg
      @metric['daily'].values.first['avg']
    end
  end
end
