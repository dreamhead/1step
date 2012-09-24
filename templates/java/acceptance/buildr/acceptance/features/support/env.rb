require 'rspec/expectations'
require 'capybara/cucumber'
require 'gizmo'

Capybara.default_driver = :selenium
Capybara.app_host = "http://localhost:8080/foo"

if Object.const_defined? :Capybara
  module Capybara
    module DSL
      alias :response :page
    end
  end
end

World(Gizmo::Helpers)
World(RSpec::Matchers)