module SnowmanIO
  # Class to work with models.
  class Store
    ADMIN_PASSWORD_KEY = "admin_password_hash"

    ## Work with admin password
    def set_admin_password(password)
      SnowmanIO.redis.set(ADMIN_PASSWORD_KEY, BCrypt::Password.create(password))
    end

    def admin_password_setted?
      !!SnowmanIO.redis.get(ADMIN_PASSWORD_KEY)
    end

    def auth_admin?(password)
      BCrypt::Password.new(SnowmanIO.redis.get(ADMIN_PASSWORD_KEY)) == password
    end

    ## Work with checks
    # Returns all check IDs
    def check_ids
      SnowmanIO.redis.keys("history:*").map do |key|
        key.sub("history:", "")
      end
    end

    def check(id)
      {
        id: id,
        count: SnowmanIO.redis.llen("history:" + id),
        status: SnowmanIO.redis.get("checks:#{id}:fail_count").to_i > 0 ? 'failed' : 'success'
      }
    end

    def resolve_check(id)
      fail_count_key = "checks:#{id}:fail_count"
      SnowmanIO.redis.set(fail_count_key, 0)
    end

    def on_fail_check(id)
      fail_count_key = "checks:#{id}:fail_count"
      SnowmanIO.redis.incr(fail_count_key)
    end

    def add_history_check(id, result)
      history_key = "history:#{id}"
      SnowmanIO.redis.rpush(history_key, result.serialize)
    end
  end
end
