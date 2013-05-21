# Configure Rails Envinronment
require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] = "test"
  require File.expand_path("../dummy/config/environment.rb",  __FILE__)
  require 'rspec/rails'
  require 'capybara/rails'
  require 'capybara/rspec'

  ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

  Tinycms::Engine.routes.default_url_options = {:host => "test.host"}

  RSpec.configure do |config|
    config.use_transactional_fixtures = true
    config.include UseRouteTinycms, :type => :controller
    config.include Tinycms::Engine.routes.url_helpers
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
end
