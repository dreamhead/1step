require 'cucumber/rake/task'

module Buildr
  module Cucumber
    module ProjectExtension
      include Extension

      after_define do |project|
        if project.packages.any? {|package| package.war? }
          ::Cucumber::Rake::Task.new(:acceptance => project.task('jetty:run')) do |t|
            t.cucumber_opts = ["acceptance/features"]
          end
        end
      end
    end
  end
end

class Buildr::Project
  include Buildr::Cucumber::ProjectExtension
end