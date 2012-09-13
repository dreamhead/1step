require 'erb'

module Firstep
  module Java
    class ProjectGenerator
      include FileUtils
      include Template

      def initialize(arguments)
        @build_generator = {
          :gradle => GradleBuildGenerator,
          :buildr => BuildrBuildGenerator
        }[arguments[:build]]
      end

      attr_reader :layout

      def create(project_name, target_directory)
        project_base = File.join(target_directory, project_name)
        create_project_with_template(
          project_base, 
          :language => 'java', 
          :type => 'jar', 
          :build => 'buildr') { |content| ERB.new(content).result(binding) }

        # @layout = ProjectLayout.create(project_name, target_directory)
        # @layout.create

        # @build_generator.create(layout.project_base)
      end
    end
  end
end