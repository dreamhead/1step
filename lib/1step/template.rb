require 'fileutils'
require 'yaml'

module Firstep
  module Template
    include FileUtils

    TEMPLATE_EXT = '.erb'
    FIRSTEP_FILE = '1stepfile'
    def create_project_with_template target_base, options, &block
      mkdir_p target_base

      template_dir = template_target(options)
      firstep_file = File.join(template_dir, FIRSTEP_FILE)
      create_project_with_firstep_file firstep_file, target_base, &block if File.exists?(firstep_file)

      Dir.glob("#{template_dir}/**/*") do |file| 
        cp_file file, template_dir, target_base, &block unless file.end_with?(FIRSTEP_FILE)
      end
    end

    def create_project_with_firstep_file firstep_file, target_base, &block
      configuration = YAML.load_file(firstep_file)
      configuration['dependencies'].each do |options|
        create_project_with_template target_base, options, &block
      end
    end

    def cp_file file, source, target, &block
      relative_path = file[source.size..-1]

      return mkdir_p File.join(target, relative_path) if File.directory?(file)
      return cp file, File.join(target, File.dirname(relative_path)) if File.extname(file) != TEMPLATE_EXT
      target_file = File.join(target, relative_path)
      content = yield File.read(file)
      File.write(target_file[0..-(TEMPLATE_EXT.size + 1)], content)
    end

    def template_target(options)
      language = options[:language] || options['language']
      type = options[:type] || options['type']
      build = options[:build] || options['build']

      File.join(template_base, language.to_s, type.to_s, build.to_s)
    end

    def template_base
      @template_base ||= File.expand_path(File.join(File.dirname(__FILE__), '..','..', 'templates'))
    end
  end
end