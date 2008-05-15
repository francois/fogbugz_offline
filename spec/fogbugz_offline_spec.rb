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
