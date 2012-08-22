module Firstep
  module Java
    class ProjectGenerator
      def create(project_name, target_directory)
        layout = ProjectLayout.create(target_directory, project_name)
        layout.create
      end
    end
  end
end