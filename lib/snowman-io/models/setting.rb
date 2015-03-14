module SnowmanIO
  class Setting
    include Mongoid::Document
    field :name, type: String
    field :value
  end
end
