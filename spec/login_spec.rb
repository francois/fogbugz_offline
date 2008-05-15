require File.dirname(__FILE__) + "/spec_helper"

describe FogbugzOffline::Commands::Login do
  before do
    @login = FogbugzOffline::Commands::Login.new
    FogbugzOffline.stub!(:global).and_return(@global = stub_everything("global"))
    FogbugzOffline.stub!(:connection_to).and_return(@connection = stub_everything("connection"))
  end

  it "should grab a Connection from FogbugzOffline#connection_to" do
    FogbugzOffline.should_receive(:connection_to).with("http://fogbugz.project.com/").and_return(@connection)
    @login.run(:url => "http://fogbugz.project.com/", :email => "francois", :password => "my-password")
  end

  it "should call Connection#login" do
    @connection.should_receive(:login).with("francois", "my-password").and_return("0123456")
    @login.run(:url => "http://my.project.com", :email => "francois", :password => "my-password")
  end

  it "should record the token in the global configuration" do
    @connection.stub!(:login).and_return("0123")
    @global.should_receive(:add_token).with("http://your.project.com/", "0123")
    @login.run(:url => "http://your.project.com/", :email => "francois", :password => "my-password")
  end

  it "should write the global configuration" do
    @global.should_receive(:write)
    @login.run(:url => "http://your.project.com/", :email => "francois", :password => "my-password")
  end
end
