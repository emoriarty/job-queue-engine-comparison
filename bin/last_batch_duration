#!/usr/bin/env ruby

puts RUBY_DESCRIPTION
# load rails app
APP_PATH = File.expand_path("../config/application", __dir__)
require_relative "../config/boot"
require APP_PATH # require application.rb

Rails.application.require_environment!

puts "Rails app loaded!"

first_job = GoodJob::Job.all.order(finished_at: :asc).select(:finished_at).first
last_job = GoodJob::Job.all.order(finished_at: :asc).select(:finished_at).last
seconds = (last_job.finished_at - first_job.finished_at) % 60
minutes = ((last_job.finished_at - first_job.finished_at) / 60) % 60
hours = (((last_job.finished_at - first_job.finished_at) / 60) /60) % 60

puts format("%02d:%02d:%02d", hours, minutes, seconds)
