require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'tmpdir'

describe "source layout" do  
  it "should layout as default" do
    Firstep::Java::ProjectGenerator.new.create("foo", Dir::tmpdir)

    project_base = File.join(Dir::tmpdir, "foo")
    source_base = File.join(project_base, "src")
    test_base = File.join(project_base, "test")
    File.should be_exist(project_base)
    File.should be_exist(source_base)
    File.should be_exist(test_base)
  end
end