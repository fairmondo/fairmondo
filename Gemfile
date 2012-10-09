source 'http://rubygems.org'

#Rails
gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Jruby Deps
platforms :jruby do
  gem "jruby-openssl"
  gem 'trinidad'
  gem 'activerecord-jdbc-adapter', '1.2.2'
  gem 'activerecord-jdbcmysql-adapter', '1.2.2'
  #gem 'activerecord-jdbcpostgresql-adapter'
  gem 'jdbc-mysql', :require => false
  #gem 'jdbc-postgres'
end

# Ruby Deps
platforms :ruby do
  gem 'sqlite3'
  gem 'therubyracer'
end

# Forms & Upload
gem "paperclip", "~> 3.0"
gem 'formtastic', " ~> 2.2.1"


# CSS
gem 'less';
gem 'less-rails-bootstrap'
gem 'formtastic-bootstrap'
gem 'bootstrap-will_paginate'

# JS
gem 'rails3-jquery-autocomplete'
gem 'tinymce-rails'
gem 'jquery-rails'

# Tool Libs

gem 'json'
gem 'tabulous'
gem 'enumerize'
gem 'will_paginate', '~> 3.0'

# Indexing /Searching
gem 'acts_as_indexed'

# Controller Gems
gem 'devise'

# Deploy with Capistrano
gem 'capistrano'

# Deal with Money
gem 'money-rails'

# State Machines in Rails
gem 'state_machine'

#Follow Users and Auctions 
gem "acts_as_follower"

# Should be only in development but else migration fails
gem 'factory_girl_rails'
gem 'faker'

#Active Admin
gem 'activeadmin'
gem 'sass-rails'
gem "meta_search", '>= 1.1.0.pre'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  platforms :jruby do
    gem 'jdbc-sqlite3'
    gem 'activerecord-jdbcsqlite3-adapter'
  end

  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyrhino' , '~> 1.73.3'

  gem 'uglifier', '>= 1.0.3'
end

# for generating *.war file
group :development do
  gem "warbler", "~> 1.3.2"
  gem "jruby-rack", "~> 1.1.10"

end

# Testing using RSpec
group :development, :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'ZenTest'
  gem 'autotest-growl'
  gem 'autotest-fsevent'
  gem 'simplecov'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# To use debugger
# gem 'ruby-debug'
