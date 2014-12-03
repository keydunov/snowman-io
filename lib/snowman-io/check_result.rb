module SnowmanIO
  class CheckResult < Struct.new(:check, :status, :message)
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
