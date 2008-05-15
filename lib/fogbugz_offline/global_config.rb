require "yaml"

module FogbugzOffline
  class GlobalConfig
    attr_reader :path, :config

    def initialize(path)
      @path = path

      begin
        @config = YAML.load_file(@path)
      rescue SystemCallError
        @config = Hash.new
      end
    end

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

    def write
      @path.dirname.mkdir unless @path.dirname.directory?
      File.open(@path, "wb") do |io|
        YAML.dump(@config, io)
      end
    end
  end
end
