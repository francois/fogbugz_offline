require File.dirname(__FILE__) + "/spec_helper"

describe FogbugzOffline::Connection, "#initialize" do
  it "should accept a URL string" do
    lambda { FogbugzOffline::Connection.new("http://my.project.com") }.should_not raise_error
  end

  it "should accept a URI object" do
    lambda { FogbugzOffline::Connection.new(URI.parse("http://my.project.com")) }.should_not raise_error
  end

  it "should convert URL string to URI object" do
    FogbugzOffline::Connection.new("http://my.project.com").root_uri.should be_kind_of(URI)
  end
end

describe FogbugzOffline::Connection, "#validate!" do
  before do
    @url = "http://fogbugz.my-install.com/"
    @connection = FogbugzOffline::Connection.new(@url)
    @connection.stub!(:get).and_return(VALID_XML_RESPONSE)
  end

  it "should open the URI for reading" do
    @connection.should_receive(:get).with(URI.parse(@url).merge("api.xml")).and_return(VALID_XML_RESPONSE)
    @connection.validate!
  end

  it "should record the API URI" do
    @connection.stub!(:get).and_return(NON_STANDARD_API_LOCATION_XML_RESPONSE)
    @connection.validate!
    @connection.api_uri.should == URI.parse(@url).merge("some-api-location.asp?")
  end

  it "should raise a NoApiAtLocation when the #get call raises a SystemException" do
    @connection.stub!(:get).and_raise(Errno::ECONNREFUSED)
    lambda { @connection.validate! }.should raise_error(FogbugzOffline::NoApiAtLocation)
  end

  it "should raise a NoApiAtLocation when the #get call raises an OpenURI::HTTPError" do
    @connection.stub!(:get).and_raise(OpenURI::HTTPError.new("failed error", StringIO.new))
    lambda { @connection.validate! }.should raise_error(FogbugzOffline::NoApiAtLocation)
  end

  it "should raise an InvalidApiResponse when the #get call returns a non-XML, non-XML valid document" do
    @connection.stub!(:get).and_return(HTML_RESPONSE)
    lambda { @connection.validate! }.should raise_error(FogbugzOffline::InvalidApiResponse)
  end

  it "should raise an InvalidApiResponse when the #get call returns a non-XML document" do
    @connection.stub!(:get).and_return(VALID_HTML_RESPONSE)
    lambda { @connection.validate! }.should raise_error(FogbugzOffline::InvalidApiResponse)
  end

  it "should raise an InvalidApiResponse when the #get call returns an XML document with no <url> element" do
    @connection.stub!(:get).and_return(MISSING_URL_ELEMENT_XML_RESPONSE)
    lambda { @connection.validate! }.should raise_error(FogbugzOffline::InvalidApiResponse)
  end

  it "should return self" do
    @connection.validate!.should == @connection
  end

  VALID_XML_RESPONSE = <<EOF
<?xml version="1.0" encoding="UTF-8" ?>
<response>
  <version>5</version>
  <minversion>1</minversion>
  <url>api.asp?</url>
</response>
EOF

  MISSING_URL_ELEMENT_XML_RESPONSE = <<EOF
<?xml version="1.0" encoding="UTF-8" ?>
<response>
  <version>5</version>
  <minversion>1</minversion>
</response>
EOF

  NON_STANDARD_API_LOCATION_XML_RESPONSE = <<EOF
<?xml version="1.0" encoding="UTF-8" ?>
<response>
  <version>5</version>
  <minversion>1</minversion>
  <url>some-api-location.asp?</url>
</response>
EOF

  HTML_RESPONSE = <<EOF
<html>
  <head>
    <title>Bleh, you missed!</title>
  </head>
  <body>
    <p>This is the test, you stupid git!
  </body>
</html>
EOF

  VALID_HTML_RESPONSE = <<EOF
<html>
  <head>
    <title>Bleh, you missed!</title>
  </head>
  <body>
    <p>This is the test, you stupid git!</p>
  </body>
</html>
EOF
end
