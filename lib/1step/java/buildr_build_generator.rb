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
        %Q{#{to_requires}

repositories.remote << 'http://repo1.maven.org/maven2'

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
end

Buildr.projects.each do |project|
  task :default => [#{to_global_dependenies}]
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
        as_configurations.compact.join("\n\n  ")
      end

      def as_configurations
        configurations.map {|config| config.extend(BuildrConfig).task_config}
      end

      def to_global_dependenies
        configurations.map do |config|
          %Q{project.task('#{config.extend(BuildrConfig).task_name}')}
        end.join(", ")
      end

      def to_requires
        %Q{require 'buildr/java/cobertura'}
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

      module BuildrConfig
        def task_name
          {
            'checkstyle' => 'checkstyle',
            'cobertura' => 'cobertura:check'
          }[name]
        end

        def task_config
          {'checkstyle' => %Q{checkstyle.configuration_file = _('config/checkstyle/checkstyle.xml')
  checkstyle.fail_on_error = true},
        'cobertura' => %Q{cobertura.check.branch_rate = 100
  cobertura.check.line_rate = 100}
          }[name]
        end
      end
    end
  end
end