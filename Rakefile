#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
ENV['SKIP_RAILS_ADMIN_INITIALIZER']='true' # supress RailsAdmin warnings

Fairnopoly::Application.load_tasks

require "rake/testtask"

Rails::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
end

Rails::TestTask.new("test:features" => "test:prepare") do |t|
  t.pattern = "test/features/**/*_test.rb"
end

Rails::TestTask.new("test:helpers" => "test:prepare") do |t|
  t.pattern = "test/helpers/**/*_test.rb"
end

Rails::TestTask.new("test:libs" => "test:prepare") do |t|
  t.pattern = "test/libs/**/*_test.rb"
end

Rails::TestTask.new("test:helper" => "test:prepare") do |t|
  t.pattern = "test/helper/**/*_test.rb"
end

Rails::TestTask.new("test:objects" => "test:prepare") do |t|
  t.pattern = "test/objects/**/*_test.rb"
end

Rails::TestTask.new("test:policies" => "test:prepare") do |t|
  t.pattern = "test/policies/**/*_test.rb"
end

Rails::TestTask.new("test:workers" => "test:prepare") do |t|
  t.pattern = "test/workers/**/*_test.rb"
end