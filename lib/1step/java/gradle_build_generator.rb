module Firstep
  module Java
    class GradleBuildGenerator
      include DefaultDependencies

      attr_reader :build_file_name

      def initialize
        @build_file_name = 'build.gradle'
      end

      def create project_base
        File.open(File.join(project_base, build_file_name), "w") { |file| file.write(content) }
      end

      def content
        %Q{apply plugin: 'java'
version = '1.0.0'

repositories {
  mavenCentral()
}

dependencies {
  #{to_dependencies}
}}
      end

      def to_dependencies
        to_compile.join('\n') + "\n  " + to_test_compile.join('\n')
      end

      def to_test_compile
        test_compile_dependencies.map {|dependency| dependency.extend(Gradle).as_test_compile }
      end

      def to_compile
        compile_dependencies.map {|dependency| dependency.extend(Gradle).as_compile }
      end


      def self.create project_base
        GradleBuildGenerator.new.create project_base
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