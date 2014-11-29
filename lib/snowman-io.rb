require "snowman-io/version"
require "snowman-io/api"

module SnowmanIO
  def self.start
    # start Sinatra based Web UI
    API.run!
  end
end
