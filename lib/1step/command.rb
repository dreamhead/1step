require 'thor'

module Firstep
  class Command < Thor
  	desc 'new project_name', 'create a new project'
  	method_option :war, :default => false, :aliases => "-w", :desc => "create Java web project"
  	def new(project_name)
      generator = options[:war] ? Java::WebGenerator : Java::ProjectGenerator
      target_directory = '.'
      generator.new(:build => :buildr).create(project_name, target_directory)
  	end
  end
end
