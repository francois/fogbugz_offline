require File.dirname(__FILE__) + "/spec_helper"

describe FogbugzOffline::Commands::Init do
  before do
    @init = FogbugzOffline::Commands::Init.new

    FogbugzOffline.stub!(:global).and_return(@global_config = stub_everything("global config"))
    @global_config.stub!(:known_url?).and_return(true)
    @global_config.stub!(:write).and_return(true)

    FogbugzOffline.stub!(:local).and_return(@local_config = stub_everything("local config"))
    @local_config.stub!(:write).and_return(true)

    FogbugzOffline.stub!(:connection_to).and_return(@connection = stub_everything("connection"))
  end

  it "should validate the project's URL against the live server" do
    FogbugzOffline.should_receive(:connection_to).with("http://fogbugz.my-project.com/").and_return(@connection)
    @connection.should_receive(:validate!)
    @init.run("http://fogbugz.my-project.com/")
  end

  it "should add the project's URL to the global configuration" do
    @global_config.should_receive(:add_project).with("http://fogbugz.my-project.com/")
    @init.run("http://fogbugz.my-project.com/")
  end

  it "should tell the global config to write itself to disk" do
    @global_config.should_receive(:write)
    @init.run("http://fb.your-fogbugz.com/")
  end

  it "should set the local config's project to the correct URL" do
    @local_config.should_receive(:set_project).with("http://my.project.com/")
    @init.run("http://my.project.com/")
  end

  it "should tell the local config to write itself to disk" do
    @local_config.should_receive(:write)
    @init.run("http://fb.your-fogbugz.com/")
  end

  it "should raise a NoValidToken when the config doesn't know about the URL" do
    @global_config.stub!(:known_url?).and_return(false)
    lambda { @init.run("http://my.fogbugz.com/") }.should raise_error(FogbugzOffline::NoValidToken)
  end
end
