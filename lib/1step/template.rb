require 'fileutils'

module Firstep
  module Template
    include FileUtils

    TEMPLATE_EXT = '.erb'
    def create_project_with_template target_base, options, &block
      mkdir_p target_base

      template_dir = template_target(options)
      Dir.glob("#{template_dir}/**/*") do |file| 
        cp_file file, template_dir, target_base, &block
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
      language = options[:language]
      type = options[:type]
      build = options[:build]

      File.join(template_base, language, type, build)     
    end

    def template_base
      @template_base ||= File.expand_path(File.join(File.dirname(__FILE__), '..','..', 'templates'))
    end
  end
end