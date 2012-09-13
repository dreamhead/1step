require 'buildr/checkstyle'

module Buildr
  module Checkstyle
    class << self
      def plain_check(configuration_file, source_paths, options = {})
        dependencies = (options[:dependencies] || []) + self.dependencies
        cp = Buildr.artifacts(dependencies).each(&:invoke).map(&:to_s)

        args = []
        if options[:properties_file]
          args << "-p"
          args << options[:properties_file]
        end
        args << "-c"
        args << configuration_file
        source_paths.each do |source_path|
          args << "-r"
          args << source_path
        end

        begin
          Java::Commands.java 'com.puppycrawl.tools.checkstyle.Main', *(args + [{:classpath => cp, :properties => options[:properties], :java_args => options[:java_args]}])
        rescue => e
          raise e if options[:fail_on_error]
        end
      end
    end

    module PlainExtension
      include Extension

      after_define do |project|
        if project.checkstyle.enabled?
          puts "define new task"
          desc "Analyzing soure code with checkstyle."
          project.task("checkstyle") do
            puts "Checkstyle: Analyzing source code..."
            Buildr::Checkstyle.plain_check(project.checkstyle.configuration_file,
                                           project.checkstyle.source_paths.flatten.compact,
                                           :properties => project.checkstyle.properties,
                                           :fail_on_error => project.checkstyle.fail_on_error?,
                                           :dependencies => project.checkstyle.extra_dependencies)

          end
        end
      end
    end
  end
end


class Buildr::Project
  include Buildr::Checkstyle::PlainExtension
end