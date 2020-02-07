#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

Fairmondo::Application.configure do
# Settings specified here will take precedence over those in config/application.rb

# Code is not reloaded between requests
  config.cache_classes = true
  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_files = false

  # Compress JavaScripts and CSS
  config.assets.js_compressor = :uglifier

  # Compile assets that are not required in the application.js
  config.assets.precompile += %w(ajax_history.js)

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # allow cross origin framing
  config.action_dispatch.default_headers = { 'X-Frame-Options' => '' }

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  #config.action_controller.asset_host = "assets%d.fairmondo.de"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { host: 'www.fairmondo.de', protocol: 'https' }

  config.dependency_loading = true if $rails_rake_task
  #http://stackoverflow.com/questions/4300240/rails-3-rake-task-cant-find-model-in-production

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = [I18n.default_locale]

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  Paperclip.options[:command_path] = "/usr/bin"

  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings  = {
    port: 25,
    authentication: :login,
    address: Rails.application.secrets.actionmailer_address,
    user_name: Rails.application.secrets.actoinmailer_username,
    password: Rails.application.secrets.actionmailer_password
  }

  # Premailer configuration
  Premailer::Rails.config.merge!(base_url: "https://www.fairmondo.de")

  # Set host by default
  Rails.application.routes.default_url_options[:host] = 'https://www.fairmondo.de'

  # Memcached
  config.cache_store = :dalli_store, '10.0.2.181', { :namespace => "fairmondo", :expires_in => 1.day, :compress => true }

  # Rack-Rewrite paths
  require "#{config.root}/config/rewrites.rb"
  config.middleware.insert_before(Rack::Runtime, Rack::Rewrite, klass: Rack::Rewrite::FairmondoRuleSet)

  # Better logging
  config.lograge.enabled = true

  # Notify exceptions by email
  config.middleware.use ExceptionNotification::Rack,
    ignore_crawlers: %w{Googlebot bingbot},
    email: {
      email_prefix: '[Production] ',
      sender_address: %{"Exception notifier" <notifier@fairmondo.de>},
      exception_recipients: %w{exceptions@fairmondo.de}
    }
end
