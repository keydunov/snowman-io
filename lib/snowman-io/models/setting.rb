module SnowmanIO
  class Setting
    include Mongoid::Document
    field :name, type: String
    field :value

    def self.set(key, value)
      Setting.find_or_create_by!(name: key).update_attributes!(value: value)
    end

    def self.get(key)
      Setting.where(name: key).first.try(:value)
    end
  end
end
