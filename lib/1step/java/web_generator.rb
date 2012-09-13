module Firstep
  module Java
    class WebGenerator
      def initialize(arguments)
        @project_generator = ProjectGenerator.new(arguments)
        @web_xml_generator = WebXmlGenerator.new
      end

      def create(project_name, target_directory)
        @project_generator.create(project_name, target_directory)
        @web_layout = WebLayout.create(@project_generator.layout)
        @web_layout.create

        @web_xml_generator.create(project_name, @web_layout.web_config_dir)
      end      
    end
  end
end