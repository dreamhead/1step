module Firstep
  module Java
    module BuildGenerator
      include DefaultDependencies

      def create project_base
        @project_base = project_base
        File.open(File.join(project_base, build_file_name), "w") { |file| file.write(content) }
      end

      def project_name
        File.basename(@project_base)
      end

      def self.included base
        if base.is_a? Class
          base.extend BuildGeneratorClassMethod
        end
      end

      module BuildGeneratorClassMethod
        def create project_base
          self.new.create(project_base)
        end
      end
    end
  end
end