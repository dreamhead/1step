module Firstep
  module Java
    class GradleBuildGenerator
      include BuildGenerator

      DEFAULT_SEP = "\n  "

      def build_file_name
        'build.gradle'
      end

      def content
        %Q{#{to_plugins}
version = '1.0.0'

repositories {
  mavenCentral()
}

dependencies {
  #{to_dependencies}
}}
      end

      def to_plugins
        default_plugins.map { |plugin| "apply plugin: '#{plugin}'"}.join("\n")
      end

      def default_plugins
        %W{java checkstyle}
      end

      def to_dependencies
        to_compile.join(DEFAULT_SEP) + DEFAULT_SEP + to_test_compile.join(DEFAULT_SEP)
      end

      def to_test_compile
        test_compile_dependencies.map {|dependency| dependency.extend(Gradle).as_test_compile }
      end

      def to_compile
        compile_dependencies.map {|dependency| dependency.extend(Gradle).as_compile }
      end

      module Gradle
        def as_gradle_dependency
          %Q{'#{group_id}:#{artifact_id}:#{version}'}
        end

        def as_test_compile
          'testCompile ' + as_gradle_dependency
        end

        def as_compile
          'compile ' + as_gradle_dependency
        end
      end
    end
  end
end