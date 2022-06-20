source 'http://rubygems.org'

# Rails
gem 'rails', '~> 5.1.7'
gem 'rails-observers' # observers got extracted since rails 4
gem 'activerecord-session_store' # sessions in activerecord

# Plattforms Ruby
platforms :ruby do
  gem 'therubyracer' # js runtime
  gem 'pg', '~> 0.21' # postgres
end

# ----------  Model ----------

gem 'paperclip', '4.2.4'
gem 'money-rails', '> 0.12.0' # dealing with money in activerecord
gem 'monetize' # parsing money
gem 'enumerize', '>= 0.5.1' # enums as symbols in ar
gem 'state_machines' # State Machines in Rails
gem 'amoeba'
gem 'sanitize' # Parser based sanitization
gem 'awesome_nested_set', '3.1.3'
gem 'friendly_id', '>= 4.0.9' # Friendly_id for beautiful links

# pseudo models
gem 'active_data'

## Indexing /Searching
gem 'chewy', '= 5.0.0'
gem 'elasticsearch', '= 5.0.5'
gem 'faraday', '0.15.4'

# ---------- View ----------

gem 'slim-rails'
gem 'jbuilder'

## CSS
gem 'susy'
gem 'sass-rails'
gem 'bourbon', '4.3.4'
gem 'font-awesome-rails', '>= 4.2.0.0'
gem 'sprite-factory'
gem 'chunky_png' # needed for sprite-factory

## JS
gem 'jquery-ui-rails', '~> 5.0.4'
gem 'qtip2-jquery-rails'
gem 'i18n-js'
gem 'coffee-rails'
gem 'therubyrhino'
gem 'selectivizr-rails'
gem 'uglifier'
gem 'modernizr-rails'
gem 'tinymce-rails', '4.3.8'
gem 'tinymce-rails-langs', '4.20140129'
gem 'jquery-rails'
gem 'rails-timeago'
gem 'handlebars_assets'

## Forms

gem 'formtastic'
gem 'recaptcha', require: 'recaptcha/rails' # Captcha Gem

# ---------- Controller ----------

gem 'canonical-rails' # canonical view links
gem 'devise'
gem 'pundit' # authorization
gem 'kaminari' # pagination
gem 'responders'

# # ---------- Mail ----------

gem 'premailer-rails'

# # ---------- Background Processing ----------

gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'delayed_paperclip', '2.9.2'
gem 'bluepill' # legacy, remove when eye stable
gem 'eye'
gem 'redis-namespace'

# # ---------- Tools ----------

gem 'dalli' # Memcached Client
gem 'kontoapi-ruby' # KontoAPI checks bank data
gem 'ibanomat' # accound number to IBAN
gem 'memoist' # Support for memoization
gem 'rails_admin', '>= 0.6.6' # Administrative backend
gem 'rails_admin_statistics', github: 'KonstantinKo/rails_admin_statistics'
gem 'rails_admin_nested_set'
gem 'rack-rewrite' # Redirects
gem 'nokogiri'
gem 'prawn_rails' # pdf generation

# ---------- Monitoring ----------
gem 'newrelic_rpm',  group: [:production, :staging]
gem 'rack-mini-profiler'
gem 'lograge'
gem 'exception_notification'

# ---------- API ----------

# Gem for connecting to FastBill Automatic
gem 'fastbill-automatic', github: 'marcaltmann/fastbill-automatic'

gem 'savon' # interacing with other SOAP apis:
gem 'rubyntlm' # https://github.com/savonrb/savon/issues/593

# Paypal integration
gem 'paypal_adaptive'

# ---------- Development ----------

group :development do
  # Better error messages
  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'letter_opener' # emails in browser

  # I18n Tools
  # gem 'i18n-tasks', '~> 0.8.3' # uncomment if needed

  # Capistrano deployment
  gem 'capistrano-rails', '~> 1.1.3'
  gem 'capistrano-bundler', '~> 1.6'
  gem 'capistrano-rbenv'
end

group :test do
  # rails
  gem 'rails-controller-testing'

  gem 'minitest-spec-rails'

  gem 'shoulda', '~> 3.5'
  gem 'shoulda-matchers', '~> 2.0'

  # System testst
  gem 'capybara'
	gem 'selenium-webdriver'

  # mocks and stubs
  gem 'minitest-rails', '~> 3.0'
  gem 'mocha'
  gem 'webmock'
  gem 'fakeredis'
  gem 'rack-contrib' # fake fastbill

  # Gem for testing emails
  gem 'email_spec'
  # email_spec uses minitest-matchers, it's incompatible to minitest 6 though; in consequence
  # mailer tests that use email_spec need to be updated when migrating to minitest 6
  gem 'minitest-matchers'

  # Code Coverage
  gem 'simplecov'
  gem 'coveralls', require: false
end

group :development, :test do
  gem 'pry-rails' # pry is awsome
  gem 'pry-byebug' # kickass debugging

  # static code analysis
  gem 'rails_best_practices'
  gem 'brakeman'
  gem 'rubocop' # style enforcement
  gem 'bullet' # Notify about n+1 queries
  gem 'puma' # Replace Webrick
end

group :development, :test, :staging do
  gem 'factory_bot_rails', '~> 4.11.1'
  gem 'faker'
end
