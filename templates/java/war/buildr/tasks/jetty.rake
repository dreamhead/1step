require 'buildr/jetty'

module Buildr
  module JettyExtension
    module ArchiveTaskExtension
      def war?
        false
      end
    end

    module WarTaskExtension
      def war?
        true
      end
    end

    VERSION = "6.1.3"
    SLF4J_VERSION = "1.4.3"

    # Libraries used by Jetty.
    REQUIRES = [ "org.mortbay.jetty:jetty:jar:#{VERSION}", "org.mortbay.jetty:jetty-util:jar:#{VERSION}",
      "org.mortbay.jetty:servlet-api-2.5:jar:#{VERSION}", "org.slf4j:slf4j-api:jar:#{SLF4J_VERSION}",
      "org.slf4j:slf4j-simple:jar:#{SLF4J_VERSION}", "org.slf4j:jcl104-over-slf4j:jar:#{SLF4J_VERSION}" ]

    Java.classpath <<  REQUIRES

    class Config
      attr_writer :port, :context_path

      def port
        @port || 8080
      end

      def context_path
        @context_path || project.name
      end

      protected

      def initialize(project)
        @project = project
      end

      attr_reader :project
    end

    class DynamicJetty
      Server = Java.org.mortbay.jetty.Server
      Connector = Java.org.mortbay.jetty.nio.SelectChannelConnector
      WebAppContext = Java.org.mortbay.jetty.webapp.WebAppContext

      def self.start(project, port, context_path = "")
        server = Server.new
        connector = Connector.new
        connector.setPort(port)
        server.addConnector(connector)

        context = WebAppContext.new
        web_root = project.path_to(:src, :main, :webapp)
        context.setResourceBase(web_root)
        context.setDescriptor(File.join(web_root, 'WEB-INF/web.xml'))
        context.setContextPath("/#{context_path}")

        war_package = project.packages.find {|package| package.war? }

        extra_path = [
          project.path_to(:target, :main, :classes),
          project.path_to(:target, :resources),
          war_package.libs
        ]
        
        context.setExtraClasspath(extra_path.join(';'))
        server.setHandler(context)
        server.start
      end
    end

    module ProjectExtension
      include Extension

      def dynamic_jetty
        @dynamic_jetty ||= Buildr::JettyExtension::Config.new(project)
      end

      after_define do |project|
        if project.packages.any? {|package| package.war? }
          desc 'run with jetty'
          project.task('jetty') do
            DynamicJetty.start(project, project.dynamic_jetty.port, project.dynamic_jetty.context_path)
            Readline::readline('[Type ENTER to stop Jetty]')
          end

          desc 'run war package with jetty'
          project.task('jetty:war') do |task|
            project.jetty.deploy("http://localhost:#{project.dynamic_jetty.port}/#{project.dynamic_jetty.context_path}", task.prerequisites.first)
            Readline::readline('[Type ENTER to stop Jetty]')
          end

          project.task('jetty' => project.compile)
          project.task('jetty:war' => [project.package(:war), project.jetty.use])
        end
      end
    end
  end
end

class Buildr::ArchiveTask
  include Buildr::JettyExtension::ArchiveTaskExtension
end

class Buildr::Packaging::Java::WarTask
  include Buildr::JettyExtension::WarTaskExtension
end

class Buildr::Project
  include Buildr::JettyExtension::ProjectExtension
end