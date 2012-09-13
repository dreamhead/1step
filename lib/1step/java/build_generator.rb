require 'fileutils'

module Firstep
  module Java
    module BuildGenerator
      include DefaultDependencies
      include DefaultConfigurations

      def create project_base
        @project_base = project_base
        @config_base = File.join(@project_base, 'config')

        File.open(File.join(project_base, build_file_name), "w") { |file| file.write(content) }
        create_configurations(@project_base)
      end

      def project_name
        File.basename(@project_base)
      end

      def self.included base
        if base.is_a? Class
          base.extend BuildGeneratorClassMethod
        end
      end

      def create_configurations(project_base)
        configurations.each do|configuration|
          configuration.items.each do |item|
            real_target_dir = File.join(@project_base, item.target_directory)
            FileUtils.mkdir_p(real_target_dir)

            FileUtils.cp(item.file, File.join(real_target_dir, File.basename(item.file)))
          end
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