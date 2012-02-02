#!/usr/bin/env bash
current_dir=`pwd`
PROJECT=`basename $current_dir`
RUBY_VERSION='1.9.3-p0'
RUBY_VERSION_WITH_GEMSET="$RUBY_VERSION@$PROJECT"
RUBY="ruby-$RUBY_VERSION"
RVMRC="rvm use --create $RUBY_VERSION_WITH_GEMSET"

function log {
  echo "*** $1"
}

function check_ruby_environment {
  check_rvm && check_ruby && check_bundler
}

function check_rvm {
  hash rvm || install_rvm
  load_rvm
  log "rvm installed"
}

function load_rvm {
  [[ -s ~/.rvm/scripts/rvm ]] && . ~/.rvm/scripts/rvm
}

function install_rvm {
  log "installing rvm"
  bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
  echo 'export rvm_project_rvmrc=1' >> $HOME/.rvmrc
}

function check_ruby {
  rvm list | grep $RUBY_VERSION > /dev/null || install_ruby
  rvm use $RUBY_VERSION_WITH_GEMSET
  log "ruby installed"
}

function prepare_project_rvmrc {
  echo 'rvm_install_on_use_flag=1' >> .rvmrc
  echo $RVMRC >> .rvmrc
}

function install_ruby {
  log "installing ruby" &&
  rvm pkg install readline &&
  rvm install $RUBY -C "-with-readline-dir=$HOME/.rvm/usr" && \
  prepare_project_rvmrc
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

function install_bundle {
  log "install bundle"
  bundle install
  log "bundle installed"
}

function prepare_dev_environment {
  check_ruby_environment && install_bundle
}

function main {
  prepare_dev_environment
}

main $@
