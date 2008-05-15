require "fogbugz_offline/config"
require "fogbugz_offline/connection"
require "fogbugz_offline/commands"

module FogbugzOffline
  def self.config
    FogbugzOffline::Config.instance
  end

  def self.connection_to(url)
    FogbugzOffline::Connection.new(url)
  end

  class NoValidToken < RuntimeError
    def initialize(url)
      super("You have never logged in to #{url}.\n  fogbugz_offline login --email you@yourdomain.com --password thepassword #{url}\n\nwill generate a token for you.")
    end
  end
end
