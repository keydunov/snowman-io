module SnowmanIO
  class Delete
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    field :model_kind, type: String
    field :model_id, type: String
  end
end
