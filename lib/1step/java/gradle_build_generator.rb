module Firstep
  class GradleBuildGenerator
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
  testCompile 'junit:junit:4.10'
}}
    end

    def self.create project_base
      GradleBuildGenerator.new.create project_base
    end
  end
end