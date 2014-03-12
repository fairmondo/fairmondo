source 'http://rubygems.org'

#Rails
gem 'rails', '~> 3.2.17'

# Ruby Deps
platforms :ruby do
  gem 'sqlite3'
  # gem 'activerecord-postgresql-adapter'
  gem 'therubyracer'
  group :production do
    gem 'pg'
  end
  unless ENV["CI"]
    group :development, :test do
      gem 'debugger'
      gem 'debugger-linecache'
    end
  end

end

# Forms & Upload
gem "paperclip", ">= 3.0"
gem 'formtastic'
gem "recaptcha", :require => "recaptcha/rails" #Captcha Gem

# Tool Libs

gem 'haml'
gem 'json'
gem 'enumerize', '>= 0.5.1'
gem 'money-rails', "~> 0.8.1" # Deal with Money
gem 'state_machine' # State Machines in Rails
gem "friendly_id", ">= 4.0.9" # Friendly_id for beautiful links
gem 'awesome_nested_set' # tree structure for categories
gem 'amoeba'
gem 'sanitize' # Parser based sanitization
gem 'strong_parameters' # Rails 4-like mass-assignment protection


# Indexing /Searching
gem 'sunspot_rails' , '~> 2.0.0'

# Sidekiq
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'sidekiq-failures'

# Sidekiq Integrations
gem "sunspot-queue" # sidekiq
gem 'delayed_paperclip', :github => 'fairnopoly/delayed_paperclip'

# Controller Gems
gem 'devise' # authentication
gem 'inherited_resources' # dry controllers
gem "pundit" # authorization

# Support for memoization
gem 'memoist'

# Should be only in development but else migration fails
gem 'factory_girl_rails'
gem 'faker'

# Rails Admin
gem 'rails_admin' , "0.4.9"

# Assets that need to be toplevel
gem 'tinymce-rails'
gem 'tinymce-rails-langs'
gem 'jquery-rails'

# KontoAPI checks bank data
gem 'kontoapi-ruby'
#KntNr to IBAN
gem 'ibanomat'

# Gem for connecting to FastBill Automatic
gem 'fastbill-automatic', git: 'git://github.com/reputami/fastbill-automatic.git', tag: 'v0.0.3'

# Paypal integration
gem 'paypal_adaptive'

# Gems used only for assets and not required
# in production environments by default.
group :assets do

   # CSS
  gem 'sass-rails'
  gem "font-awesome-rails"
  gem "susy"
  gem "compass", "~> 0.13.alpha.12"
  gem 'compass-rails'


  # JS
  gem 'jquery-ui-rails'
  gem 'i18n-js', :git => 'https://github.com/fnando/i18n-js.git', :branch => 'master'
  gem 'coffee-rails'
  gem 'therubyrhino'
  gem 'selectivizr-rails'
  gem 'uglifier'
  gem 'modernizr-rails'
  # gem 'turbolinks'
  # gem 'jquery-turbolinks'
end

group :production, :staging do
  gem 'newrelic_rpm' #Monitoring service
  # gem 'whenever' # cron jobs
end

# Testing using RSpec
group :development, :test do

  # Capistrano
  gem 'capistrano-rails', '~> 1.0.0'
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-bundler', '~> 1.1.2'

  # Main Test Tools
  gem 'rspec-rails'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'capybara'

  # Gem for testing emails
  gem "email_spec"

  # Code Coverage
  gem 'simplecov'
  gem 'coveralls', require: false
  # Mutation Coverage
  # gem 'mutant-rails' ... check back to see if they got it working: https://github.com/mockdeep/mutant-rails

  # er diagramm generation
  gem "rails-erd"

  # sunspot solr test gem
  gem "sunspot_test"

  # test suite additions
  gem "rails_best_practices"
  gem "brakeman" # security test: execute with 'brakeman'
  gem 'rspec-instafail'

  # Replace Webrick
  gem 'thin'

  # Notify about n+1 queries
  gem 'bullet', github: 'flyerhzm/bullet'

end

group :development do
  # Better error messages
  gem 'better_errors'
  gem 'binding_of_caller'

  # HAML Conversion tools
  gem "erb2haml"
  gem "html2haml"
end

group :test do
  # Sqlite inmemory fix
  gem 'memory_test_fix'

  gem 'rake'
  gem 'database_cleaner'
  gem 'colorize'
  gem "fakeredis", :require => "fakeredis/rspec"
  gem "fakeweb", "~> 1.3"
end

group :development,:test,:staging do
  gem 'sunspot_solr' , '~> 2.0.0'
end
