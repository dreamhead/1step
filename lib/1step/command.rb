require 'thor'

module Firstep
  class Command < Thor
  	desc 'new project_name', 'create a new project'
  	method_option :war, :default => false, :aliases => "-w", :desc => "create Java web project"
  	def new(project_name)
      project_options = {
        :language => :java, 
        :type => :jar, 
        :build => :buildr
      }

      project_options[:type] = :war if options[:war]
      target_directory = '.'
      Java::ProjectGenerator.new(project_options).create(project_name, target_directory)
  	end
  end
end
