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
    def register_check(name, sha1)
      unless SnowmanIO.redis.get("checks:#{name}:sha1") == sha1
        if SnowmanIO.redis.get("checks:#{name}:sha1")
          positive = SnowmanIO.redis.get("checks:#{name}:positive_count")
          failed = SnowmanIO.redis.get("checks:#{name}:fail_count")
          add_check_history_entry(name, "sha1 changes [#{positive}/#{failed}]")
        end
        SnowmanIO.redis.set("checks:#{name}:sha1", sha1)
        SnowmanIO.redis.set("checks:#{name}:positive_count", 0)
        SnowmanIO.redis.set("checks:#{name}:fail_count", 0)
      end
    end

    def checks
      SnowmanIO.redis.keys("checks:*:sha1").map do |key|
        key.split(":", 3)[1]
      end
    end

    def check(name)
      {
        id: name,
        positive_count: SnowmanIO.redis.get("checks:#{name}:positive_count"),
        fail_count: SnowmanIO.redis.get("checks:#{name}:fail_count"),
        status: SnowmanIO.redis.get("checks:#{name}:fail_count").to_i > 0 ? 'failed' : 'success',
        raw_history: SnowmanIO.redis.lrange("checks:#{name}:history", 0, -1).map { |entry|
          JSON.load(entry)
        }.to_json
      }
    end

    def check_on_handle(name, is_failed)
      if is_failed
        SnowmanIO.redis.incr("checks:#{name}:fail_count")
      else
        SnowmanIO.redis.incr("checks:#{name}:positive_count")
      end

      failed = SnowmanIO.redis.get("checks:#{name}:fail_count").to_i

      if failed > 1
        :failed_already
      elsif failed == 1
        :failed
      else
        :success
      end
    end

    def resolve_check(name)
      positive = SnowmanIO.redis.get("checks:#{name}:positive_count")
      failed = SnowmanIO.redis.get("checks:#{name}:fail_count")
      add_check_history_entry(name, "manual resolve [#{positive}/#{failed}]")
      SnowmanIO.redis.set("checks:#{name}:positive_count", 0)
      SnowmanIO.redis.set("checks:#{name}:fail_count", 0)
    end

    private

    def add_check_history_entry(name, reason)
      SnowmanIO.redis.lpush("checks:#{name}:history", {at: Time.now.to_s, reason: reason}.to_json)
      while SnowmanIO.redis.llen("checks:#{name}:history") > 10
        SnowmanIO.redis.rpop("checks:#{name}:history")
      end
    end
  end
end
