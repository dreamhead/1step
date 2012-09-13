require 'fileutils'

module Firstep
  module Java
    class ProjectLayout
      include FileUtils

      def self.create project_name, target_directory
        project_base = File.join(target_directory, project_name)
        code_base = File.join(project_base, 'src')
        source_base = File.join(code_base, 'main')
        test_base = File.join(code_base, 'test')
        java_source_base = File.join(source_base, 'java')
        java_test_base = File.join(test_base, 'java')

        ProjectLayout.new(project_base, source_base, test_base, java_source_base, java_test_base)
      end

      attr_reader :project_base, :source_base, :test_base

      def initialize(project_base, source_base, test_base, java_source_base, java_test_base)
        @project_base = project_base
        @source_base = source_base
        @test_base = test_base
        @java_source_base = java_source_base
        @java_test_base = java_test_base
      end

      def create
        mkdir_p(@project_base)
        mkdir_p(@java_source_base)
        mkdir_p(@java_test_base)
      end
    end
  end
end