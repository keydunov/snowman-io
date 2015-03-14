module SnowmanIO
  module StorageImpl
    module System
      def set(key, value)
        Setting.find_or_create_by!(name: key).update_attributes!(value: value)
      end

      def get(key)
        Setting.where(name: key).first.try(:value)
      end
    end
  end 
end
