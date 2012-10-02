require 'rspec/expectations'
require 'capybara/cucumber'
require 'gizmo'

Capybara.default_driver = :selenium

#TODO change this url to your project url
Capybara.app_host = "http://localhost:8080/sample"

if Object.const_defined? :Capybara
  module Capybara
    module DSL
      alias :response :page
    end
  end
end

World(Gizmo::Helpers)
World(RSpec::Matchers)
