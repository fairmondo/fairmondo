#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

Fairmondo::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false
  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :file

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Do not compress assets
  config.assets.js_compressor = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Mailer example config
=begin
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "",
    :port                 => 587,
    :domain               => '',
    :user_name            => '',
    :password             => '',
    :authentication       => 'login',
    :enable_starttls_auto => true  }

  # Don't care if the mailer can't send
  # config.action_mailer.raise_delivery_errors = false
=end

  # Deactivate the mailer
  config.action_mailer.perform_deliveries = true

  # or set it to :test, so you can check the mailer queue (e.g. in the debugger)
  # without actually sending anything
  config.action_mailer.delivery_method = :letter_opener

  # bullet - n+1 detection
  config.after_initialize do
    Bullet.enable = true
    Bullet.add_footer = true
    Bullet.console = true
    Bullet.bullet_logger = true
    Bullet.rails_logger = true
    # Bullet.growl = true
    # Bullet.xmpp = { :account  => 'bullets_account@jabber.org',
    #                 :password => 'bullets_password_for_jabber',
    #                 :receiver => 'your_account@jabber.org',
    #                 :show_online_status => true }
    # Bullet.airbrake = true
  end

  # allow cross origin framing
  config.action_dispatch.default_headers = { 'X-Frame-Options' => '' }

  # Configure Quiet Assets https://github.com/evrone/quiet_assets
  # to turn asset pipeline logging back on, uncomment the following line
  # config.quiet_assets = false

  # Set host by default
  Rails.application.routes.default_url_options[:host] = 'localhost:3000'
end
