module SnowmanIO
  # Class to work with models.
  class Store
    ADMIN_PASSWORD_KEY = "admin_password_hash"
    BASE_URL_KEY = "base_url"

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
  end
end
