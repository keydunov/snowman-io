module SnowmanIO
  class Storage
    ADMIN_PASSWORD_KEY = "admin_password_hash"
    BASE_URL_KEY = "base_url"
    NEXT_REPORT_DATE = "next_report_date"
    TODAY = "today"
    METRICS_TOTAL_COUNT = "metrics_total_count"
    METRICS_TODAY_COUNT = "metrics_today_count"

    include StorageImpl::System
    include StorageImpl::Metrics
    include StorageImpl::Aggregation
    include StorageImpl::Reports
    include StorageImpl::Apps

    def dashboard
      {
        metrics: {
          today: get(METRICS_TODAY_COUNT) || 0,
          total: Utils.human_value(get(METRICS_TOTAL_COUNT) || 0)
        }
      }
    end

    private

    # Mongo ObjectId => String ID
    def idfy(obj)
      if obj.is_a?(Array)
        obj.map { |o| idfy(o) }
      elsif obj.is_a?(Hash)
        obj.merge("id" => obj.delete("_id").to_s)
      end
    end
  end
end
