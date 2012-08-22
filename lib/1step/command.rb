require 'thor'

module Firstep
  class Command < Thor
  	desc 'new project_name', 'create a new project'
  	def new(project_name)
      target_directory = '.'
      Java::ProjectGenerator.new.create(project_name, target_directory)
  	end
  end
end
