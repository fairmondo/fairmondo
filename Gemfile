source 'http://rubygems.org'

# Rails
gem 'rails', '~> 4.1.16'
gem 'rails-observers', '~> 0.1.2'
gem 'activerecord-session_store', '~> 0.1.2'

# Plattforms Ruby
platforms :ruby do
  gem 'sqlite3', '~> 1.3.13', group: :test
  gem 'therubyracer', '~> 0.12.3'
  gem 'pg', '~> 0.18.4', group: [:production, :staging, :development]
end

# ----------  Model ----------

gem 'paperclip', '~> 4.2.2'
gem 'money-rails', '~> 1.2.0'
gem 'monetize', '~> 1.1.0'
gem 'enumerize', '~> 0.9.0' # enums as symbols in ar
gem 'state_machine', '~> 1.2.0'
gem 'amoeba', '~> 3.0.0'
gem 'sanitize', '~> 3.1.0' # Parser based sanitization
gem 'awesome_nested_set', '~> 3.0.2'
gem 'friendly_id', '~> 5.0.4'

# pseudo models
gem 'active_data', '~> 0.3.0'

## Indexing /Searching
gem 'chewy', '~> 0.6.2'
# ---------- View ----------

gem 'slim-rails', '~> 3.1.2'
gem 'jbuilder', '~> 2.2.6'

## CSS
gem 'susy', '~> 2.1.1'
gem 'sass-rails', '~> 5.0.6'
gem 'bourbon', '<= 4.0.2'
gem 'font-awesome-rails', '~> 4.2.0.0'
gem 'sprite-factory', '~> 1.6.1'
gem 'chunky_png', '~> 1.3.3' # needed for sprite-factory
gem 'sprockets', '~> 3.7.1'

## JS
gem 'jquery-ui-rails', '~> 5.0.3'
gem 'qtip2-jquery-rails', '~> 2.1.107'
gem 'i18n-js', '~> 3.0.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'therubyrhino', '~> 2.0.4'
gem 'selectivizr-rails', '~> 1.1.2'
gem 'uglifier', '~> 2.7.2'
gem 'modernizr-rails', '~> 2.7.1'
gem 'tinymce-rails', '~> 4.1.10'
gem 'tinymce-rails-langs'
gem 'jquery-rails', '~> 3.1.3'
gem 'rails-timeago', '~> 2.11.1'
gem 'wiselinks', '~> 1.2.1'
gem 'handlebars_assets', '~> 0.23.1'

## Forms

gem 'formtastic', '~> 2.3.0.rc3'
gem 'recaptcha', '~> 0.3.6', require: 'recaptcha/rails'

# ---------- Controller ----------

gem 'arcane', '~> 1.1.1' # Parameter management for strong_parameters
gem 'canonical-rails', '~> 0.0.7' # canonical view links
gem 'devise', '~> 3.5.10'
gem 'pundit', '~> 0.3.0'
gem 'kaminari', '~> 0.16.1'
gem 'responders', '~> 1.1.2'

# ---------- Mail ----------

gem 'premailer-rails', '~> 1.9.3'

# ---------- Background Processing ----------

gem 'sidekiq', '~> 4.1.2'
gem 'sidekiq-scheduler', '~> 2.0'
gem 'sinatra', '~> 1.4.5', require: nil
gem 'delayed_paperclip', '~> 2.9.2'
gem 'bluepill', '~> 0.0.69' # legacy, remove when eye stable
gem 'eye', '~> 0.8.1' # sidekiq process monitoring
gem 'redis-namespace', '~> 1.5.2'

# ---------- Tools ----------

gem 'dalli', '~> 2.7.2'
gem 'kontoapi-ruby', '~> 0.3.0'
gem 'ibanomat', '~> 0.0.5'
gem 'memoist', '~> 0.11.0' # Support for memoization
gem 'rails_admin', '~> 0.6.6'
gem 'rails_admin_statistics', github: 'KonstantinKo/rails_admin_statistics'
gem 'rails_admin_nested_set', '~> 0.4.0'
gem 'rack-rewrite', '~> 1.5.1' # Redirects
gem 'json', '~> 1.8.6'
gem 'nokogiri', '~> 1.7.2'
gem 'prawn_rails', '~> 0.0.11'

# ---------- Monitoring ----------
gem 'newrelic_rpm',  group: [:production, :staging]
gem 'rack-mini-profiler', '~> 0.10.1'
gem 'lograge', '~> 0.3.0'
gem 'exception_notification', '~> 4.1.1'

# ---------- API ----------

# Gem for connecting to FastBill Automatic
gem 'fastbill-automatic', github: 'marcaltmann/fastbill-automatic'

gem 'savon', '~> 2.8.0' # interacing with other SOAP apis:
gem 'rubyntlm', '~> 0.4.0' # https://github.com/savonrb/savon/issues/593

# Paypal integration
gem 'paypal_adaptive', '~> 0.3.10'

# ---------- Development ----------

group :development do
  gem 'better_errors', '~> 2.1.0'
  gem 'binding_of_caller', '~> 0.7.2'

  gem 'letter_opener', '~> 1.3.0'

  gem 'quiet_assets', '~> 1.1.0'  # Quiet Assets to disable asset pipeline in log
  gem 'rails-erd', '~> 1.1.0'  # er diagramm generation
  gem 'thin', '~> 1.6.3'  # Replace Webrick

  gem 'i18n-tasks', '~> 0.8.3'
  gem 'spring', '~> 1.6.4'
end

group :test do
  gem 'memory_test_fix'  # Sqlite inmemory fix
  gem 'rake', '~> 12.0.0'
  gem 'database_cleaner', '~> 1.4.0'
  gem 'colorize', '~> 0.7.5'
  gem 'fakeredis', '~> 0.5.0'
  gem 'fakeweb', '~> 1.3'
  gem 'webmock', '~> 1.21.0'
  gem 'rack-contrib', '~> 1.2.0'
end

group :development, :test do
  gem 'parallel_tests'
  gem 'pry-rescue'
  gem 'pry-rails'
  gem 'hirb'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'

  # Capistrano
  gem 'capistrano-rails', '~> 1.1.3'
  gem 'capistrano', '~> 3.3.5'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rbenv', '~> 2.0.2'

  gem 'minitest', '5.10.1'  # 5.10.2 is buggy with this Rails version
  gem 'minitest-matchers', '~> 1.4.1'
  gem 'minitest-line', '~> 0.6.2'
  gem 'launchy' # save_and_open_page
  gem 'shoulda', '~> 3.5.0'
  gem 'minitest-rails-capybara', '~> 2.1.1'
  gem 'mocha', '~> 1.1.0'

  # Gem for testing emails
  gem 'email_spec', '~> 1.6.0'

  # Code Coverage
  gem 'simplecov', '~> 0.9.1'
  gem 'simplecov-json', require: false
  gem 'coveralls', require: false

  # test suite additions
  gem 'rails_best_practices', '~> 1.15.4'
  gem 'brakeman', github: 'presidentbeef/brakeman'  # security test: execute with 'brakeman' locked because of slim https://github.com/presidentbeef/brakeman/pull/602/files
  gem 'rubocop', '~> 0.29.0'

  gem 'bullet', '~> 4.14.0' # Notify about n+1 queries
end

group :development, :test, :staging do
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'ffaker', '~> 1.25.0'

  # styleguides
  gem 'nkss-rails', github: 'nadarei/nkss-rails'
end
