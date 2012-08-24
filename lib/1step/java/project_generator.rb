module Firstep
  module Java
    class ProjectGenerator
      def initialize(arguments)
        @build_generator = {
          :gradle => GradleBuildGenerator,
          :buildr => BuildrBuildGenerator
        }[arguments[:build]]
      end

      def create(project_name, target_directory)
        layout = ProjectLayout.create(project_name, target_directory)
        layout.create

        @build_generator.create(layout.project_base)
      end
    end
  end
end