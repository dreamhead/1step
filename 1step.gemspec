# -*- encoding: utf-8 -*-
require File.expand_path('../lib/1step/version', __FILE__)

puts "hello"

Gem::Specification.new do |gem|
  puts "world"
  gem.authors       = ["Ye Zheng"]
  gem.email         = ["dreamhead.cn@gmail.com"]
  gem.description   = %q{A command line tool to kick off a software project.}
  gem.summary       = %q{A command line tool to kick off a software project, which helps you setup development environment with best practice.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "1step"
  gem.require_paths = ["lib"]
  gem.version       = FIRSTEP::VERSION

  gem.add_runtime_dependency 'thor', '>= 0.16.0'
end
