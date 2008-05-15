require "uri"
require "open-uri"
require "rexml/document"
require "rexml/xpath"

module FogbugzOffline
  class Connection
    attr_reader :root_uri, :api_uri

    def initialize(url)
      @root_uri = url.respond_to?(:merge) ? url : URI.parse(url)
    end

    def validate!
      xml_api_uri = @root_uri.merge("api.xml")
      document = nil
      begin
        xml = get(xml_api_uri)
        document = REXML::Document.new(xml)
        api_url = REXML::XPath.first(document.root, "//response/url/text()")
        raise FogbugzOffline::InvalidApiResponse.new(xml_api_uri, document) if api_url.nil? || api_url.to_s.strip.empty?
        @api_uri = @root_uri.merge(api_url.to_s)
        self
      rescue REXML::ParseException
        raise FogbugzOffline::InvalidApiResponse.new(xml_api_uri, document)
      rescue SystemCallError, OpenURI::HTTPError
        raise FogbugzOffline::NoApiAtLocation.new(@root_uri.to_s)
      end
    end

    protected
    def get(uri)
    end
  end
end
