#!/usr/bin/env bash
current_dir=`pwd`
PROJECT=`basename $current_dir`
RUBY_VERSION='1.9.3-p0'
RUBY_VERSION_WITH_GEMSET="$RUBY_VERSION@$PROJECT"
RUBY="ruby-$RUBY_VERSION"
RVMRC="rvm use --create $RUBY_VERSION_WITH_GEMSET"

function log {
  printf "***%b\n" "$*" ; return $? ;
}

function check_ruby_environment {
  check_rvm && check_ruby && check_bundler
}

function is_old_rvm {
  is_old=`rvm version | sed '/^$/d' | awk '{print $2}' | awk -F . '{ if($1 > 1 || $2 >=10) { print 0 } else { print 1 } }'`
  [[ is_old -eq 0 ]] && return 1 || return 0
}

function rvm_exists {
  hash rvm
}

function reinstall_rvm_for_old_version {
  is_old_rvm && reinstall_rvm
}

function check_rvm { 
  if [ rvm_exists ]; then
    load_rvm && reinstall_rvm_for_old_version
  else
    install_rvm
  fi
  log "rvm installed"
}

function reload_rvm {
  rvm reload
}

function load_rvm {
  [[ -s ~/.rvm/scripts/rvm ]] && . ~/.rvm/scripts/rvm
}

function install_rvm {
  log "installing rvm"
  bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
  echo 'export rvm_project_rvmrc=1' >> $HOME/.rvmrc
}

function reinstall_rvm {
  log 'rvm version is too old and reinstall rvm'
  install_rvm && reload_rvm
}

function create_project_rvmrc {
  echo 'rvm_install_on_use_flag=1' >> .rvmrc
  echo $RVMRC >> .rvmrc
}

function prepare_project_rvmrc {
  [ -s .rvmrc ] || create_project_rvmrc
}

function check_ruby {
  rvm list | grep $RUBY_VERSION > /dev/null || install_ruby
  prepare_project_rvmrc
  rvm use $RUBY_VERSION_WITH_GEMSET
  log "ruby installed"
}

function install_ruby {
  log "installing ruby" &&
  rvm pkg install readline &&
  rvm install $RUBY -C "-with-readline-dir=$HOME/.rvm/usr"
}

function check_bundler {
  which bundle | grep $RUBY > /dev/null || install_bundler
  log "bundler installed"
}

function install_bundler {
  log "installing bundler"
  gem sources | grep "http://rubygems.org/" || gem sources -a http://rubygems.org/ && \
  gem install bundler --no-ri --no-rdoc
}

function create_gemfile {
  echo "source \"http://rubygems.org\"" >> Gemfile
  echo "" >> Gemfile
  echo "group(:test) do" >> Gemfile
  echo "  gem 'rspec'" >> Gemfile
  echo "end" >> Gemfile
}

function create_lib_dir {
  mkdir -p lib
}

function create_spec_helper {
  echo "require 'rubygems'" >> spec/spec_helper.rb
  echo "require 'rspec'" >> spec/spec_helper.rb
  echo "" >> spec/spec_helper.rb
  echo "\$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')" >> spec/spec_helper.rb
}

function create_spec_dir {
  mkdir -p spec
  [ -s spec/spec_helper.rb ] || create_spec_helper
}

function check_spec_dir {
  [ -d spec ] || create_spec_dir
}

function create_rakefile {
  echo "require 'rspec/core/rake_task'" >> Rakefile
  echo "" >> Rakefile
  echo "desc 'Default: run specs.'" >> Rakefile
  echo "task :default => :spec" >> Rakefile
  echo "" >> Rakefile
  echo "desc 'Run specs'" >> Rakefile
  echo "RSpec::Core::RakeTask.new" >> Rakefile
}

function check_rakefile {
  [ -s Rakefile ] || create_rakefile
}

function create_project_skeleton {
  create_lib_dir && \
  check_spec_dir && \
  check_rakefile
}

function check_project_skeleton {
  log "create project skeleton"
  create_project_skeleton
  log "project skeleton created"
}

function check_gemfile {
  [ -s .Gemfile ] || create_gemfile
}

function install_bundle {
  check_gemfile 
  log "install bundle"
  bundle install && \
  log "bundle installed"
}

function prepare_dev_environment {
  check_ruby_environment && install_bundle && check_project_skeleton
}

function main {
  prepare_dev_environment
}

main $@
