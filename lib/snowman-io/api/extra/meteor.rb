module SnowmanIO
  module API
    module Extra
      module Meteor
        def self.model_all(key, model, last)
          if last
            at = Time.at(last)
            now = Time.now

            if last == 0
              deleted = []
            else
              deleted = Delete.where(model_kind: model.to_s, :created_at.gte => at, :created_at.lt => now).map(&:model_id)
            end

            {
              key => model.where(:updated_at.gte => at, :updated_at.lt => now),
              deleted: deleted,
              last: now.to_i
            }
          else
            { key => model.all }
          end
        end

        def self.model_destroy(model, record)
          Delete.create!(model_kind: model.to_s, model_id: record.id.to_s)
          record.destroy
        end
      end
    end
  end
end
