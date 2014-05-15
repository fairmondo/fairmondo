source 'http://rubygems.org'

#Rails
gem 'rails', '~> 4.1.1'
gem 'rails-observers'
gem 'activerecord-session_store'

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
      gem 'byebug'
    end
  end

end

# Forms & Upload
gem "paperclip", ">= 3.0"
gem 'formtastic', "~> 2.3.0.rc3"
gem "recaptcha", :require => "recaptcha/rails" #Captcha Gem
gem 'virtus'

# Tool Libs

gem 'haml'
gem 'json'
gem 'enumerize', '>= 0.5.1'
gem 'money-rails'
gem 'state_machine' # State Machines in Rails
gem "friendly_id", ">= 4.0.9" # Friendly_id for beautiful links
gem 'awesome_nested_set' , ">= 3.0.0.rc.4"# tree structure for categories
gem 'amoeba'
gem 'sanitize' # Parser based sanitization


# Indexing /Searching
gem "tire"

# Sidekiq
gem 'sidekiq'

gem 'sinatra', '>= 1.3.0', :require => nil

gem 'bluepill' #sidekiq process monitoring


# Memcached
gem 'dalli'

# Sidekiq Integrations
gem 'delayed_paperclip'

# Controller Gems
gem 'devise' # authentication
gem 'inherited_resources' # dry controllers
gem "pundit" # authorization

# Support for memoization
gem 'memoist'

# Rails Admin
gem 'rails_admin'

#Monitoring
gem 'peek'
gem 'peek-git'
gem 'peek-gc'
gem 'peek-dalli'
gem 'peek-performance_bar'
gem 'peek-pg'
gem 'peek-sidekiq'
gem 'peek-rblineprof'




# KontoAPI checks bank data
gem 'kontoapi-ruby'
#KntNr to IBAN
gem 'ibanomat'


# Gem for connecting to FastBill Automatic
gem 'fastbill-automatic', git: 'git://github.com/reputami/fastbill-automatic.git', tag: 'v0.0.3'

# Gems used only for assets and not required
# in production environments by default.

 # CSS
gem 'sass-rails'
gem "font-awesome-rails"
gem "susy" , "~>1.0.9"
gem "compass", "~> 0.13.alpha.12"
gem 'compass-rails'
gem 'sprockets', "2.11.0"

# JS
gem 'jquery-ui-rails'
gem 'i18n-js'
gem 'coffee-rails'
gem 'therubyrhino'
gem 'selectivizr-rails'
gem 'uglifier'
gem 'modernizr-rails'
# gem 'turbolinks'
# gem 'jquery-turbolinks'
gem 'tinymce-rails'
gem 'tinymce-rails-langs'
gem 'jquery-rails'


group :production, :staging do
  #gem 'newrelic_rpm' #Monitoring service
  # gem 'whenever' # cron jobs
end

# Testing using RSpec
group :development, :test do

  # Capistrano
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rbenv'

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

  # test suite additions
  gem "rails_best_practices"
  gem 'brakeman'  # security test: execute with 'brakeman'
  gem 'rspec-instafail'

  # Replace Webrick
  gem 'thin'

  # Notify about n+1 queries
  gem 'bullet'

  # Guard test automation
  gem 'guard-rspec'
  gem 'guard'
  gem 'guard-ctags-bundler'

  # MetaRequest for usage with RailsPanel Chrome Extension
  gem 'meta_request'
end

group :development do
  gem 'spring'

  # Better error messages
  gem 'better_errors'
  gem 'binding_of_caller'

  # HAML Conversion tools
  #gem "erb2haml" see html2haml
  #gem "html2haml" need to wait for new release 2.0.0 is still in beta if you need it
  gem 'letter_opener'
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
  gem 'factory_girl_rails'
  gem 'faker'
end
