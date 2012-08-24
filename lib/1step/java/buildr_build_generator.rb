module Firstep
  module Java
    class BuildrBuildGenerator
      include BuildGenerator

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
    end
  end
end