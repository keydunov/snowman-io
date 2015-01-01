require 'action_view'

module SnowmanIO
  # Class to work with models.
  class Store
    ADMIN_PASSWORD_KEY = "admin_password_hash"
    BASE_URL_KEY = "base_url"

    # Very ugly solution to get `time_ago_in_words` method
    class ActionViewHelpers
      include ActionView::Helpers::DateHelper
    end

    ## Work with admin password
    def set_admin_password(password)
      SnowmanIO.adapter.set(ADMIN_PASSWORD_KEY, BCrypt::Password.create(password))
    end

    def admin_password_setted?
      !!SnowmanIO.adapter.get(ADMIN_PASSWORD_KEY)
    end

    def auth_admin?(password)
      BCrypt::Password.new(SnowmanIO.adapter.get(ADMIN_PASSWORD_KEY)) == password
    end

    ## Base url
    def set_base_url(url)
      SnowmanIO.adapter.set(BASE_URL_KEY, url)
    end

    def base_url
      SnowmanIO.adapter.get(BASE_URL_KEY)
    end

    ## Work with checks
    # Returns all check IDs
    def register_check(name, sha1)
      unless SnowmanIO.adapter.get("checks@#{name}@sha1") == sha1
        if SnowmanIO.adapter.get("checks@#{name}@sha1")
          add_check_history_entry(name, "sha1 updated")
        else
          add_check_history_entry(name, "initialized")
        end
        SnowmanIO.adapter.set("checks@#{name}@sha1", sha1)
        SnowmanIO.adapter.seti("checks@#{name}@positive_count", 0)
        SnowmanIO.adapter.seti("checks@#{name}@fail_count", 0)
        # initialize times
        SnowmanIO.adapter.set("checks@#{name}@positive_from", Time.now.utc.to_s)
        SnowmanIO.adapter.set("checks@#{name}@failed_at", Time.now.utc.to_s)
      end
    end

    def save_last_check(name, context)
      SnowmanIO.adapter.set("checks@#{name}@last_check_at", Time.now.utc.to_s)
      SnowmanIO.adapter.set("checks@#{name}@last_check_context", JSON.dump(context))
    end

    def checks
      SnowmanIO.adapter.keys("checks@*@sha1").map do |key|
        key.split("@", 3)[1]
      end
    end

    def check(name)
      positive_from = SnowmanIO.adapter.get("checks@#{name}@positive_from")
      failed_at = SnowmanIO.adapter.get("checks@#{name}@failed_at")
      last_check_at = SnowmanIO.adapter.get("checks@#{name}@last_check_at")
      {
        id: name,
        positive_count: SnowmanIO.adapter.geti("checks@#{name}@positive_count"),
        fail_count: SnowmanIO.adapter.geti("checks@#{name}@fail_count"),
        status: SnowmanIO.adapter.geti("checks@#{name}@fail_count") > 0 ? 'failed' : 'success',
        raw_history: SnowmanIO.adapter.geta("checks@#{name}@history").map { |entry|
          JSON.load(entry)
        }.to_json,
        positive_from: positive_from,
        positive_from_human: "for " + ActionViewHelpers.new.time_ago_in_words(Time.parse(positive_from)),
        failed_at: failed_at,
        failed_at_human: ActionViewHelpers.new.time_ago_in_words(Time.parse(failed_at)) + " ago",
        last_check_at: last_check_at,
        last_check_at_human: ((ActionViewHelpers.new.time_ago_in_words(Time.parse(last_check_at)) + " ago") if last_check_at),
        last_check_context: (SnowmanIO.adapter.get("checks@#{name}@last_check_context") || "[]")
      }
    end

    def check_on_handle(name, is_failed)
      fail_count = SnowmanIO.adapter.geti("checks@#{name}@fail_count").to_i

      if is_failed
        SnowmanIO.adapter.incr("checks@#{name}@fail_count")
      else
        SnowmanIO.adapter.incr("checks@#{name}@positive_count")
      end

      failed = SnowmanIO.adapter.geti("checks@#{name}@fail_count").to_i

      if fail_count > 0 || failed > 1
        :failed_already
      elsif failed == 1
        :failed
      else
        :success
      end
    end

    def mark_check_as_failed(name)
      positive = SnowmanIO.adapter.geti("checks@#{name}@positive_count")
      add_check_history_entry(name, "failed after #{positive} positive check#{positive == 1 ? "" : "s"}")
      SnowmanIO.adapter.set("checks@#{name}@failed_at", Time.now.utc.to_s)
    end

    def resolve_check(name)
      add_check_history_entry(name, "resolved manual")
      SnowmanIO.adapter.set("checks@#{name}@positive_from", Time.now.utc.to_s)
      SnowmanIO.adapter.seti("checks@#{name}@positive_count", 0)
      SnowmanIO.adapter.seti("checks@#{name}@fail_count", 0)
    end

    private

    def add_check_history_entry(name, reason)
      SnowmanIO.adapter.push("checks@#{name}@history", {at: Time.now.utc.to_s, reason: reason}.to_json)
      while SnowmanIO.adapter.len("checks@#{name}@history") > 30
        SnowmanIO.adapter.shift("checks@#{name}@history")
      end
    end
  end
end
