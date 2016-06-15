#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

Fairmondo::Application.configure do
# Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = false
  config.eager_load = false

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_files = true
  config.static_cache_control = "public, max-age=3600"

  # Log error messages when you accidentally call methods on nil
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  # German should be the default test language
  config.i18n.default_locale = :de
  I18n.locale = config.i18n.locale = config.i18n.default_locale
  config.active_support.test_order = :random

  # Assets
  config.assets.compile = true
  config.assets.compress = false
  config.assets.debug = false
  config.assets.digest = false

  # commented out till next bullet release
  # bullet - n+1 detection
  #config.after_initialize do
  #  Bullet.enable = true
  #  Bullet.bullet_logger = true
  #  Bullet.raise = true
  #end

  # Set host by default
  Rails.application.routes.default_url_options[:host] = 'localhost:3000'
end
