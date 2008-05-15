require File.dirname(__FILE__) + "/spec_helper"

describe FogbugzOffline, "#home_path" do
  before do
    ENV.stub!(:[]).with("HOME").and_return("/home/someuser")
    Pathname.stub!(:new).and_return(@pathname = mock("pathname"))
    @pathname.stub!(:exist?).and_return(true)
    @pathname.stub!(:directory?).and_return(true)
  end

  it "should raise an ArgumentError if ENV does not have a key by the name HOME" do
    ENV.should_receive(:[]).with("HOME").and_return(nil)
    lambda { FogbugzOffline.home_path }.should raise_error(ArgumentError)
  end

  it "should return a Pathname with the ENV[HOME] value" do
    Pathname.should_receive(:new).with("/home/someuser").and_return(@pathname)
    FogbugzOffline.home_path
  end

  it "should raise an ArgumentError if ENV[HOME] does not exist as a path" do
    @pathname.should_receive(:exist?).and_return(false)
    lambda { FogbugzOffline.home_path }.should raise_error(ArgumentError)
  end

  it "should raise an ArgumentError if ENV[HOME] is not a directory" do
    @pathname.should_receive(:directory?).and_return(false)
    lambda { FogbugzOffline.home_path }.should raise_error(ArgumentError)
  end
end

describe FogbugzOffline, "#project_path" do
  before do
    Dir.stub!(:getwd).and_return("/home/me/project")
  end

  it "should instantiate a Pathname object" do
    Pathname.should_receive(:new).with(Dir.getwd).and_return(mock("pathname"))
    FogbugzOffline.project_path
  end

  it "should return a Pathname on the current working directory" do
    FogbugzOffline.project_path.should == Pathname.new(Dir.getwd)
  end
end

describe FogbugzOffline, "#global" do
  before do
    FogbugzOffline.stub!(:home_path).and_return(Pathname.new("/home/me"))
  end

  it "should instantiate a FogbugzOffline::GlobalConfig with #home_path + .fogbugz_offline/config.yml" do
    FogbugzOffline::GlobalConfig.should_receive(:new).with(Pathname.new("/home/me/.fogbugz_offline/config.yml")).and_return(mock("config"))
    FogbugzOffline.global
  end
end

describe FogbugzOffline, "#local" do
  before do
    FogbugzOffline.stub!(:project_path).and_return(Pathname.new("/home/me/project"))
  end

  it "should instantiate a FogbugzOffline::LocalConfig with #project_path + .fogbugz_offline/config.yml" do
    FogbugzOffline::LocalConfig.should_receive(:new).with(Pathname.new("/home/me/project/.fogbugz_offline/config.yml")).and_return(mock("config"))
    FogbugzOffline.local
  end
end
