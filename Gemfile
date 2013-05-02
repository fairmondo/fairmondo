source 'http://rubygems.org'

#Rails
gem 'rails', '>= 3.2.13'


# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Jruby Deps
platforms :jruby do
  gem "jruby-openssl"
  gem 'trinidad'
  gem 'activerecord-jdbc-adapter', '>= 1.2.9'
  #gem 'activerecord-jdbcmysql-adapter', '1.2.2'
  gem 'activerecord-jdbcpostgresql-adapter'
  #gem 'jdbc-mysql', :require => false
  gem 'jdbc-postgres'

end

# Ruby Deps
platforms :ruby do
  gem 'sqlite3'
  gem 'therubyracer'
#  gem 'activerecord-postgresql-adapter'
  gem 'pg', :group => :production
  # exclude Debugger from CI
  unless ENV["CI"]
    gem 'debugger', :group => [:development, :test]
  end
end

# Forms & Upload
gem "paperclip", ">= 3.0"
gem 'formtastic'
gem "formtastic-bootstrap"

# link inside a translation
#gem 'it'

# CSS
gem 'less-rails';
#gem 'less-rails-bootstrap'
#gem 'formtastic-bootstrap'
gem 'bootstrap-will_paginate'

gem "font-awesome-rails"

# JS
gem 'tinymce-rails'
gem 'tinymce-rails-langs'
gem 'jquery-rails'
#gem 'i18n-js', :git => 'git@github.com:fnando/i18n-js.git', :branch => 'master' # workaround 4 https://github.com/fnando/i18n-js/issues/137

# Tool Libs

gem 'haml'
gem 'json' 
gem 'enumerize', '>= 0.5.1'
gem 'will_paginate'
gem 'inherited_resources'
gem "pundit" # authorization

# Indexing /Searching
gem 'sunspot_rails'
gem 'progress_bar'

# Friendly_id for beautiful links
gem "friendly_id", ">= 4.0.9"

# Delayed_Jobs & Daemons
gem "daemons"
gem 'delayed_job_active_record'


# Controller Gems
gem 'devise'
#Captcha Gem
gem "recaptcha", :require => "recaptcha/rails"

# Deploy with Capistrano
gem 'capistrano'

# Deal with Money
gem 'money-rails'

# State Machines in Rails
gem 'state_machine'

# Follow Users and Auctions 
#gem "acts_as_follower" #not used for the moment

# tree structure for categories
gem 'awesome_nested_set'

# Should be only in development but else migration fails
gem 'factory_girl_rails'
gem 'faker'

#Rails Adminrails
gem 'rails_admin'
gem "bootstrap-sass", "2.3.1.0" # http://stackoverflow.com/questions/16323273/could-not-find-bootstrap-sass-2-3-1-1-in-any-of-the-sources-on-heroku-push

# CMS Gem
gem 'tinycms', :path => "gems/tinycms"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  platforms :jruby do
    gem 'jdbc-sqlite3'
    gem 'activerecord-jdbcsqlite3-adapter'
  end

  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyrhino' 
  gem 'selectivizr-rails'
  gem 'uglifier', '>= 1.0.3'
  gem 'modernizr-rails'
end


# for generating *.war file
#group :development do
 # gem "warbler", "~> 1.3.2"
 # gem "jruby-rack", "~> 1.1.10"

#end

# Testing using RSpec
group :development, :test do
  gem "erb2haml"
  gem "html2haml"
  gem 'rspec-rails'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem "ZenTest"
  gem 'autotest-fsevent'
  gem 'simplecov'

   #solr gem
  gem 'sunspot_solr'
  gem "sunspot_test"
  
  #security
  gem "brakeman" # security test: execute with 'brakeman'
  
  #test performance
  gem 'spork-rails'
  
  
  
end

# Adding Staging-server Embedded Solr
group :staging do
  gem 'sunspot_solr'

end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

