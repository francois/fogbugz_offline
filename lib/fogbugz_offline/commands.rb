Dir[File.dirname(__FILE__) + "/commands/*.rb"].each {|f| require f.sub(".rb", "")}

module FogbugzOffline
  module Commands
    def self.init(*args)
      FogbugzOffline::Commands::Init.new.run(*args)
    end
  end
end
