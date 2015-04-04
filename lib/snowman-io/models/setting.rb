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
    
    def self.hg_set(params)
      Setting.set(SnowmanIO::HG_STATUS, params[:hg_status])
      Setting.set(SnowmanIO::HG_KEY, params[:hg_key])
      hg_get
    end

    def self.hg_get
      if get(SnowmanIO::HG_STATUS) == "enabled"
        {hg_status: "enabled", hg_key: Setting.get(SnowmanIO::HG_KEY)}
      else
        {hg_status: "disabled", hg_key: ""}
      end
    end
  end
end
