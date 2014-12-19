module SnowmanIO
  # Class to work with storage.
  class Storage

    # Returns all check IDs from storage
    def check_ids
      SnowmanIO.redis.keys("history:*").map do |key|
        key.sub("history:", "")
      end
    end

    def check_to_json(id)
      {
        id: id,
        count: SnowmanIO.redis.llen("history:" + id),
        status: SnowmanIO.redis.get("checks:#{id}:fail_count").to_i > 0 ? 'failed' : 'success'
      }
    end
  end
end
