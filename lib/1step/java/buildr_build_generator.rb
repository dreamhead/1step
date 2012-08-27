module Firstep
  module Java
    class BuildrBuildGenerator
      include BuildGenerator

      def initialize
        checkstyle.items << checkstyle_rake
      end

      def checkstyle_rake
        ConfigItem.new(File.join(File.dirname(__FILE__), 'checkstyle', 'checkstyle.rake'), 'tasks')
      end

      def build_file_name
        'buildfile'
      end

      def content
        %Q{repositories.remote << 'http://repo1.maven.org/maven2'

compile_dependencies = struct(
  #{to_compile_dependencies}
)

test_dependencies = struct(
  #{to_test_dependencies}
)

define '#{project_name}' do
  project.version = '1.0.0'
  project.group = 'com.foobar' # TODO: change to your group

  compile.with compile_dependencies
  test.with test_dependencies

  #{to_configurations}
end}
      end

      def to_compile_dependencies
        to_current_format_dependencies compile_dependencies
      end

      def to_test_dependencies
        to_current_format_dependencies test_compile_dependencies
      end

      def to_current_format_dependencies dependencies
        dependencies.map {|dependency| dependency.extend(Buildr).as_buildr_dependency }.join(",\n  ")
      end

      def to_configurations
        as_configurations.compact.join("\n")
      end

      def as_configurations
        configurations.map {|config| checkstyle_config if config.name == 'checkstyle'}
      end

      def checkstyle_config
        %Q{checkstyle.configuration_file = _('config/checkstyle/checkstyle.xml')
  checkstyle.fail_on_error = true}
      end

      module Buildr
        def as_buildr_dependency
          %Q{#{as_ruby_symbol artifact_id} => '#{group_id}:#{artifact_id}:jar:#{version}'}
        end

        def as_ruby_symbol artifact_id
          ids = artifact_id.split('-')
          ids = ids[0..-2] if ids[-1] == 'all'
          %Q{:#{ids.join('_')}}
        end
      end

      module Checkstyle
      end
    end
  end
end