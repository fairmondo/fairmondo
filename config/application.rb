#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
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

module Fairnopoly
  class Application < Rails::Application

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib/autoload/ #{config.root}/app/models/business_transactions/ #{config.root}/app/models/images/ #{config.root}/app/models/users/)
    config.autoload_paths += %W(#{config.root}/app/objects/decorator/ #{config.root}/app/objects/form/ #{config.root}/app/objects/query/ #{config.root}/app/objects/service/ #{config.root}/app/objects/value/ #{config.root}/app/objects/view/ #{config.root}/app/objects/coercers/  #{config.root}/app/objects/abaci/ #{config.root}/app/observers)

    config.autoload_paths += %W(#{config.root}/config/initializers/sidekiq_pro.rb)


    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.

    config.active_record.observers = [:article_observer,
                                      :feedback_observer,
                                      :business_transaction_observer,
                                      :user_observer,
                                      :library_element_observer,
                                      :refund_observer,
                                      :comment_observer,
                                      :image_observer]

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Berlin'

    I18n.config.enforce_available_locales = false

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

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
    config.assets.version = '1.0'

    # controller based assets
    config.assets.precompile += Dir["app/assets/stylesheets/controller/*.scss"].map{|file| "controller/#{File.basename file,'.scss'}" }
    # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
    config.assets.precompile += %w( session_expire.js )

    config.generators.assets :controller_based_assets
    config.generators.test_framework :minitest, spec: true

    config.action_view.field_error_proc = Proc.new { |html_tag, instance| "#{html_tag}".html_safe }

    # Rack-Rewrite paths
    require "#{config.root}/config/rewrites.rb"
    config.middleware.insert_before(Rack::Runtime, Rack::Rewrite, klass: Rack::Rewrite::FairnopolyRuleSet)
  end
end
