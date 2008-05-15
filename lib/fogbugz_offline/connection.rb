require "uri"

module FogbugzOffline
  class Connection
    def initialize(url)
      @root_uri = url.respond_to?(:merge) ? url : URI.parse(url)
    end

    def validate!
    end
  end
end
