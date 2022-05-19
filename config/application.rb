#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require File.expand_path('../boot', __FILE__)

require 'csv'
require 'rails/all'
require 'net/http'
require 'susy'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Fairmondo
  class Application < Rails::Application

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    config.eager_load_paths << Rails.root.join('lib/autoload')

    # Activate observers that should always be running.

    config.active_record.observers = [:article_observer,
                                      :feedback_observer,
                                      :business_transaction_observer,
                                      :user_observer,
                                      :library_observer,
                                      :library_element_observer,
                                      :refund_observer,
                                      :comment_observer,
                                      :image_observer,
                                      :address_observer,
                                      :payment_observer]

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Berlin'

    I18n.config.enforce_available_locales = false

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path = []
    # TODO: Refactor existing locales and REMOVE:
    config.i18n.load_path +=
      Dir[Rails.root.join('config', 'locales', 'old', '**', '*.{rb,yml}')]
    # /REMOVE
    config.i18n.load_path +=
      Dir[Rails.root.join('config', 'locales', 'views', '**', '*.yml')]
    config.i18n.load_path +=
      Dir[Rails.root.join('config', 'locales', 'models', '**', '*.yml')]
    config.i18n.load_path +=
      Dir[Rails.root.join('config', 'locales', 'gems', '**', '*.yml')]

    config.i18n.default_locale = :de

    #Workaround
    I18n.locale = config.i18n.locale = config.i18n.default_locale


    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.initialize_on_precompile = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.3'

    # Enable fonts directory
    config.assets.paths << Rails.root.join("app", "assets", "fonts")

    # controller based assets
    config.assets.precompile += Dir["app/assets/stylesheets/controller/*.scss"].map{|file| "controller/#{File.basename file,'.scss'}.css" }
    # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
    config.assets.precompile += %w(
      session_expire.js unactivated_article_warning.js inputs/bank_details.js inputs/newsletter_status.js
      email/email.css
    )

    config.generators.assets :controller_based_assets
    config.generators.test_framework :minitest, spec: true

    config.action_view.field_error_proc = Proc.new { |html_tag, instance| "#{html_tag}".html_safe }

    config.active_record.belongs_to_required_by_default = false
    config.action_controller.per_form_csrf_tokens = true
    config.action_controller.forgery_protection_origin_check = true
  end
end
