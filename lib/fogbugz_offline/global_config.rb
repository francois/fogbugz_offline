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

    def write
      @path.dirname.mkdir unless @path.dirname.directory?
      File.open(@path, "wb") do |io|
        YAML.dump(@config, io)
      end
    end
  end
end
