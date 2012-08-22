require 'fileutils'

module Firstep
  module Java
    class ProjectLayout
      include FileUtils

      def self.create project_name, target_directory
        project_base = File.join(target_directory, project_name)
        source_base = File.join(project_base, 'src')
        test_base = File.join(project_base, 'test')
        ProjectLayout.new(project_base, source_base, test_base)
      end

      attr_reader :source_base, :test_base

      def initialize(project_base, source_base, test_base)
        @project_base = project_base
        @source_base = source_base
        @test_base = test_base
      end

      def create
        mkdir_p(@project_base)
        mkdir_p(@source_base)
        mkdir_p(@test_base)
      end
    end
  end
end