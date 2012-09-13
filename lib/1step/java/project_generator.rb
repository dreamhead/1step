require 'erb'

module Firstep
  module Java
    class ProjectGenerator
      include FileUtils
      include Template

      def initialize options
        @options = options
      end

      def create(project_name, target_directory)
        project_base = File.join(target_directory, project_name)
        create_project_with_template(project_base, @options) do |content| 
          ERB.new(content).result(binding) 
        end
      end
    end
  end
end