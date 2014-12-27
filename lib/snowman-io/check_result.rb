module SnowmanIO
  class CheckResult < Struct.new(:check, :status, :message, :context)
    def initialize(check, status, message, context = [])
      super
    end

    def check_name
      check.name
    end

    def fail?
      status == "failed"
    end

    def serialize
      JSON.dump({ status: status, message: message })
    end
  end
end
