require 'thor'

module Firstep
  class Command < Thor
  	desc 'new project_name', 'create a new project'
  	method_option :war, :default => false, :aliases => "-w", :desc => "create Java web project"
    method_option :antlr, :default => false, :aliases => "--antlr", :desc => "create Java antlr project" 
  	def new(project_name)
      project_options = {
        :language => :java, 
        :type => :jar, 
        :build => :buildr
      }

      project_options[:type] = :acceptance if options[:war]
      project_options[:type] = :antlr if options[:antlr]
      target_directory = '.'
      ProjectGenerator.new(project_options).create(project_name, target_directory)
  	end
  end
end
