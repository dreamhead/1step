require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'tmpdir'
require 'fileutils'

describe "java project generator" do  
  %Q{
    project 
    |
    |--src--|--main--|--java
    |       |
    |       |--test--|--java
    |
    |--buildfile
  }

  before(:each) do
    @target_dir = Dir::tmpdir
    @project_name = "foo"
    @project_base = File.join(@target_dir, @project_name)
    FileUtils.rmtree(@project_base)
  end

  # it "should layout java project as default" do
  #   Firstep::Java::ProjectGenerator.new(:build => :gradle).create(@project_name, @target_dir)
    
  #   code_base = File.join(@project_base, "src")
  #   source_base = File.join(code_base, "main")
  #   test_base = File.join(code_base, "test")
  #   java_source_base = File.join(source_base, 'java')
  #   java_test_base = File.join(test_base, 'java')

  #   File.should be_exist(@project_base)
  #   File.should be_exist(java_source_base)
  #   File.should be_exist(java_test_base)
  # end

#   it "should generate build file" do
#     Firstep::Java::ProjectGenerator.new(:build => :gradle).create("foo", Dir::tmpdir)
#     build_file = File.join(@project_base, "build.gradle")

#     File.should be_exist(build_file)
#     File.open(build_file, 'r') do |file| 
#       file.read.should == %Q{apply plugin: 'java'
# apply plugin: 'checkstyle'
# version = '1.0.0'

# repositories {
#   mavenCentral()
# }

# dependencies {
#   compile 'com.google.guava:guava:13.0'
#   compile 'joda-time:joda-time:2.1'
#   testCompile 'junit:junit:4.10'
#   testCompile 'org.mockito:mockito-all:1.9.0'
# }}
#     end
#   end
  
  it "should generate buildfile for buildr" do
    Firstep::Java::ProjectGenerator.new(:build => :buildr).create("foo", Dir::tmpdir)
    build_file = File.join(@project_base, "buildfile")
    File.should be_exist(build_file)

    checkstyle_configuration_file = File.join(@project_base, 'config', 'checkstyle', 'checkstyle.xml')
    File.should be_exist(checkstyle_configuration_file)

    checkstyle_task_file = File.join(@project_base, 'tasks', 'checkstyle.rake')
    File.should be_exist(checkstyle_task_file)

    File.open(build_file, 'r') do |file| 
      file.read.should == %Q{require 'buildr/java/cobertura'

repositories.remote << 'http://repo1.maven.org/maven2'

compile_dependencies = struct(
  :guava => 'com.google.guava:guava:jar:13.0',
  :joda_time => 'joda-time:joda-time:jar:2.1'
)

test_dependencies = struct(
  :junit => 'junit:junit:jar:4.10',
  :mockito => 'org.mockito:mockito-all:jar:1.9.0'
)

define 'foo' do
  project.version = '1.0.0'
  project.group = 'com.foobar' # TODO: change to your group

  compile.with compile_dependencies
  test.with test_dependencies

  checkstyle.configuration_file = _('config/checkstyle/checkstyle.xml')
  checkstyle.fail_on_error = true

  cobertura.check.branch_rate = 100
  cobertura.check.line_rate = 100
end

Buildr.projects.each do |project|
  task :default => [project.task('checkstyle'), project.task('cobertura:check')]
end}
    end
  end
end