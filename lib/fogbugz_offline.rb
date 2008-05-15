require "fogbugz_offline/global_config"
require "fogbugz_offline/local_config"
require "fogbugz_offline/connection"
require "fogbugz_offline/commands"

require "pathname"

module FogbugzOffline
  def self.home_path
    raise ArgumentError, "$HOME is undefined -- cannot proceed.  Define it in your environment." unless ENV["HOME"]
    pathname = Pathname.new(ENV["HOME"])
    raise ArgumentError, "$HOME is defined as #{pathname}, but does not exist." unless pathname.exist?
    raise ArgumentError, "$HOME is defined as #{pathname}, but is not a directory." unless pathname.directory?
    pathname
  end

  def self.project_path
    Pathname.new(Dir.getwd)
  end

  def self.global
    return @global_config if @global_config
    @global_config = FogbugzOffline::GlobalConfig.new(home_path + ".fogbugz_offline/config.yml")
  end

  def self.local
    return @local_config if @local_config
    FogbugzOffline::LocalConfig.new(project_path + ".fogbugz_offline/config.yml")
  end

  def self.connection_to(url)
    FogbugzOffline::Connection.new(url)
  end

  class NoValidToken < RuntimeError
    def initialize(url)
      super("You have never logged in to #{url}.\n  fogbugz_offline login --email you@yourdomain.com --password thepassword #{url}\n\nwill generate a token for you.")
    end
  end

  class NoApiAtLocation < RuntimeError
    def initialize(url)
      super("The URL #{url} does not seem to be a valid FogBugz install.")
    end
  end

  class InvalidApiResponse < RuntimeError
    def initialize(url, response)
      super("The URL #{url} returned an unpexected response: I expected XML, I got:\n#{response}")
    end
  end
end
