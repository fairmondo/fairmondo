source 'http://rubygems.org'

# Rails
gem 'rails', '~> 4.1.9'
gem 'rails-observers' # observers got extracted since rails 4
gem 'activerecord-session_store' # sessions in activerecord

# Plattforms Ruby
platforms :ruby do
  gem 'sqlite3', group: :test # sqlite3 for inmemory testing db
  gem 'therubyracer' # js runtime
  gem 'pg', group: [:production, :staging, :development] # postgres
end

# ----------  Model ----------

gem 'paperclip', '4.2.0' # image uploads ### LOCKED Paperclip at version 4.2.0 until #1706 (https://github.com/thoughtbot/paperclip/issues/1706) is fixed
gem 'money-rails', '> 0.12.0' # dealing with money in activerecord
gem 'monetize' # parsing money
gem 'enumerize', '>= 0.5.1' # enums as symbols in ar
gem 'state_machine' # State Machines in Rails
gem 'amoeba'
gem 'sanitize' # Parser based sanitization
gem 'awesome_nested_set', '>= 3.0.0.rc.4' # tree structure for categories
gem 'friendly_id', '>= 4.0.9' # Friendly_id for beautiful links

# pseudo models
gem 'active_data'

## Indexing /Searching
gem 'chewy'
# ---------- View ----------

gem 'slim-rails', '>= 2.1.5'
gem 'jbuilder'

## CSS
gem 'susy', '~> 2.1.1' # Grid framework is susy
gem 'sass-rails', '~> 5.0.0'
gem 'bourbon', '<= 4.0.2' # easy ccs3
gem 'font-awesome-rails', '>= 4.2.0.0'
gem 'sprite-factory'
gem 'chunky_png' # needed for sprite-factory
gem 'sprockets'

## JS
gem 'jquery-ui-rails'
gem 'qtip2-jquery-rails', '~> 2.1.107'
gem 'i18n-js', '~> 3.0.0.rc8'
gem 'coffee-rails'
gem 'therubyrhino'
gem 'selectivizr-rails'
gem 'uglifier'
gem 'modernizr-rails'
gem 'tinymce-rails'
gem 'tinymce-rails-langs'
gem 'jquery-rails'
gem 'rails-timeago'
gem 'wiselinks'
gem 'hogan_assets'

## Forms

gem 'formtastic', '~> 2.3.0.rc3'
gem 'recaptcha', require: 'recaptcha/rails' # Captcha Gem

# ---------- Controller ----------

gem 'arcane' # Parameter management for strong_parameters
gem 'canonical-rails' # canonical view links
gem 'devise' # authentication
gem 'pundit' # authorization
gem 'kaminari' # pagination
gem 'responders'

# ---------- Mail ----------

gem 'premailer-rails' # creates emails with inline css from html files with external css-file

# ---------- Background Processing ----------

gem 'sidekiq', '>= 3.2.5'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'delayed_paperclip' # handle image processing with sidekiq
gem 'bluepill' # legacy, remove when eye stable
gem 'eye' # sidekiq process monitoring
gem 'sidetiq' # process scheduling

# ---------- Tools ----------

gem 'dalli' # Memcached Client
gem 'kontoapi-ruby' # KontoAPI checks bank data
gem 'ibanomat' # accound number to IBAN
gem 'memoist' # Support for memoization
gem 'rails_admin', '>= 0.6.6' # Administrative backend
gem 'rails_admin_statistics', github: 'KonstantinKo/rails_admin_statistics'
gem 'rails_admin_nested_set'
gem 'rack-rewrite' # Redirects
gem 'json'
gem 'nokogiri'
gem 'prawn_rails' # pdf generation

# ---------- Monitoring ----------
gem 'newrelic_rpm',  group: [:production, :staging]
gem 'rack-mini-profiler'
gem 'lograge'
gem 'multi_logger'

# ---------- API ----------

# Gem for connecting to FastBill Automatic
gem 'fastbill-automatic', git: 'git://github.com/reputami/fastbill-automatic.git', tag: 'v0.0.3'

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

  # debugging in chrome with RailsPanel
  gem 'meta_request'

  # Quiet Assets to disable asset pipeline in log
  gem 'quiet_assets'

  # er diagramm generation
  gem 'rails-erd'
  gem 'thin' # Replace Webrick

  # Guard
  gem 'guard'
  gem 'guard-ctags-bundler'
  gem 'rb-readline'
  gem 'guard-minitest'
  gem 'guard-rubocop'
  gem 'guard-livereload', '~> 2.4', require: false

  # I18n Tools
  gem 'i18n-tasks', '~> 0.8.3'
end

group :test do
  gem 'memory_test_fix'  # Sqlite inmemory fix
  gem 'rake'
  gem 'database_cleaner'
  gem 'colorize'
  gem 'fakeredis'
  gem 'fakeweb', '~> 1.3'
end

group :development, :test do
  gem 'parallel_tests'
  gem 'pry-rescue'
  gem 'pry-rails' # pry is awsome
  gem 'hirb' # hirb makes pry output even more awesome
  gem 'pry-byebug' # kickass debugging
  gem 'pry-stack_explorer'

  # Capistrano
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rbenv'

  gem 'minitest' # Testing using Minitest
  gem 'minitest-matchers'
  gem 'minitest-line'
  gem 'launchy' # save_and_open_page
  gem 'shoulda'
  gem 'minitest-rails-capybara'
  gem 'mocha'

  # Gem for testing emails
  gem 'email_spec'

  # Code Coverage
  gem 'simplecov'
  gem 'simplecov-json', require: false
  gem 'coveralls', require: false

  # test suite additions
  gem 'rails_best_practices'
  gem 'brakeman', github: 'presidentbeef/brakeman'  # security test: execute with 'brakeman' locked because of slim https://github.com/presidentbeef/brakeman/pull/602/files
  gem 'rubocop' # style enforcement

  gem 'bullet' # Notify about n+1 queries
end

group :development, :test, :staging do
  gem 'factory_girl_rails'
  gem 'ffaker'

  # styleguides
  gem 'nkss-rails', github: 'nadarei/nkss-rails'
end
