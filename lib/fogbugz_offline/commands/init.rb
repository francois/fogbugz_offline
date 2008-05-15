module FogbugzOffline
  module Commands
    class Init
      def run(url)
        FogbugzOffline.connection_to(url).validate!

        FogbugzOffline.global.add_project(url)
        FogbugzOffline.global.write

        FogbugzOffline.local.set_project(url)
        FogbugzOffline.local.write

        raise FogbugzOffline::NoValidToken.new(url) unless FogbugzOffline.global.known_url?(url)
      end
    end
  end
end
