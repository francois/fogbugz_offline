require "fogbugz_offline/config"
require "yaml"

module FogbugzOffline
  class GlobalConfig < FogbugzOffline::Config
    def add_project(project_url)
      projects[project_url] = Array.new
    end

    def add_token(project_url, token)
      project(project_url) << token
    end

    def remove_token(project_url, token)
      project(project_url).delete(token)
    end

    def projects
      @config["projects"] ||= Array.new
    end

    def project(url)
      projects[project_url] ||= []
    end
  end
end
