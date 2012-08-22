module Firstep
  module Java
    class ProjectGenerator
      def create(project_name, target_directory)
        layout = ProjectLayout.create(project_name, target_directory)
        layout.create

        GradleBuildGenerator.create(layout.project_base)
      end
    end
  end
end