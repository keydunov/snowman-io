module SnowmanIO
  class Storage
    ADMIN_PASSWORD_KEY = "admin_password_hash"
    BASE_URL_KEY = "base_url"
    NEXT_REPORT_DATE = "next_report_date"

    include StorageImpl::System
    include StorageImpl::Metrics
    include StorageImpl::Aggregation
    include StorageImpl::Reports
    include StorageImpl::Apps

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
