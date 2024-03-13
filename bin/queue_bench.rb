#!/usr/bin/env ruby

puts RUBY_DESCRIPTION

require "bundler/setup"
Bundler.require(:default, :load_test)

# load rails app
APP_PATH = File.expand_path("../config/application", __dir__)
require_relative "../config/boot"


MyJob.perform_async
