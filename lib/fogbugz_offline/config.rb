require "singleton"

module FogbugzOffline
  class Config
    include Singleton

    def add_project(url)
    end

    def known_url?(url)
    end

    def write
    end
  end
end
