require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'tmpdir'

describe "java web project generator" do  
  %Q{
    project 
    |
    |--src--|--main--|--java
    |       |        |
    |       |        |--webapp--|--WEB-INF--|--web.xml
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

  it "should generate web.xml" do
    Firstep::Java::ProjectGenerator.new(:language => 'java', :type => 'war', :build => :buildr).create(@project_name, @target_dir)

    build_file = File.join(@project_base, "buildfile")
    File.should be_exist(build_file)

    web_xml = File.join(@project_base, 'src', 'main', 'webapp', 'WEB-INF', 'web.xml')
    File.should be_exist(web_xml)
    File.open(web_xml, 'r') do |file| 
      file.read.should == %Q{<!DOCTYPE web-app PUBLIC
        "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
        "http://java.sun.com/dtd/web-app_2_3.dtd" >

<web-app>
    <distributable/>
    <display-name>Web Application</display-name>

    <servlet>
        <servlet-name>#{@project_name}</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>/WEB-INF/servlet-context.xml</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>
</web-app>}
    end
  end
end