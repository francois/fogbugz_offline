require File.dirname(__FILE__) + "/spec_helper"
require "yaml"

describe FogbugzOffline::GlobalConfig, "#initialize" do
  before do
    YAML.stub!(:load_file).and_return(@config = {"http://my.project.com/" => []})
  end

  it "should read the config file as YAML" do
    YAML.should_receive(:load_file).with(path = mock("config file path")).and_return({})
    FogbugzOffline::GlobalConfig.new(path)
  end

  it "should rescue Errno::ENOENT and not raise any exception" do
    YAML.stub!(:load_file).and_raise(Errno::ENOENT)
    lambda { FogbugzOffline::GlobalConfig.new(mock("config file path")) }.should_not raise_error
  end

  it "should make the config available in #config" do
    global = FogbugzOffline::GlobalConfig.new(mock("config file path"))
    global.config.should == @config
  end

  it "should remember the original path in #path" do
    global = FogbugzOffline::GlobalConfig.new(path = mock("config file path"))
    global.path.should == path
  end
end

describe FogbugzOffline::GlobalConfig, "#write" do
  before do
    YAML.stub!(:load_file).and_return(@config = {"config" => "value"})
    @global = FogbugzOffline::GlobalConfig.new(@path = Pathname.new("config file path"))
    @path.stub!(:dirname).and_return(@dir = mock("config file dir"))
    @dir.stub!(:directory?).and_return(true)
    File.stub!(:open).and_yield(@io = mock("io"))
    YAML.stub!(:dump)
  end

  it "should open a File for writing on the original path" do
    File.should_receive(:open).with(@path, "wb")
    @global.write
  end

  it "should call YAML#dump with @config and @io" do
    YAML.should_receive(:dump).with(@config, @io)
    @global.write
  end

  it "should create missing directories in the path" do
    @dir.stub!(:directory?).and_return(false)
    @dir.should_receive(:mkdir)
    @global.write
  end
end
