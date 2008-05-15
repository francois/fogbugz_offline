module FogbugzOffline
  module Commands
    class Login
      def run(args)
        connection = FogbugzOffline.connection_to(args[:url])
        token = connection.login(args[:email], args[:password])
        FogbugzOffline.global.add_token(args[:url], token)
        FogbugzOffline.global.write
      end
    end
  end
end
