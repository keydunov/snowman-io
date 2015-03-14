module SnowmanIO
  class Storage
    ADMIN_PASSWORD_KEY = "admin_password_hash"
    BASE_URL_KEY = "base_url"
    NEXT_REPORT_DATE = "next_report_date"

    include StorageImpl::System
    include StorageImpl::Metrics
    include StorageImpl::Aggregation
    include StorageImpl::Reports
  end
end
