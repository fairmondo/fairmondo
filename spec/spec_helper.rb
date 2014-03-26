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
ENV["RAILS_ENV"] ||= 'test'

### General Requires ###

require 'support/spec_helpers/coverage.rb'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'sidekiq/testing'


require 'support/spec_helpers/final.rb' # ensure this is the last rspec after-suite
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# For Sidekiq
Sidekiq::Testing.inline!

# Redis
Redis.current = Redis.new


# For fixtures:
include ActionDispatch::TestProcess

# Secret Token 4 testing:
Fairnopoly::Application.config.secret_token = '599e6eed15b557a8d7fdee1672761277a174a6a7e3e8987876d9e6ac685d68005b285b14371e3b29c395e1d64f820fe05eb981496901c2d73b4a1b6c868fd771'

#~Disable logging for test performance! Change this value if you really need the log and run your suite again~
Rails.logger.level = 4

### Test Setup ###
File.open(Rails.root.join('log/test.log'), 'w') {|f| f.truncate(0) } # clear test log


silence_warnings do
  BCrypt::Engine::DEFAULT_COST = BCrypt::Engine::MIN_COST
end

tire_off

### RSpec Configurations ###

RSpec.configure do |config|

  ## Configs from presets ##

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false # We use Database cleaner for fine grained cleaning levels
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"


  ## Custom configs ##

  # Add the "visual" tag to a test that uses save_and_open_page.
  # This will give you the corresponding css and js
  if config.inclusion_filter[:visual]
    config.before(scope = :suite) do
      %x[bundle exec rake assets:precompile]
    end
  end

  # Deferred Garbage Collection for improved speed
  config.before(:all) do
    DeferredGarbageCollection.start
  end

  config.after(:all) do
    DeferredGarbageCollection.reconsider
  end

  # Expanded Test Suite Setup
  config.before :suite do


    Article.index.delete
    Article.create_elasticsearch_index


    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)

     # Initialize some Categories

    setup_categories


  end

  config.after :suite do
    rails_best_practices
    brakeman
  end

  config.before(:each) do |x|
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:all, :setup => :true) do
    DatabaseCleaner.strategy = :transaction # reset to transactional fixtures
    DatabaseCleaner.clean
  end

  config.before(:all, :search => :true) do
    tire_on
    Article.index.delete
    Article.create_elasticsearch_index

  end

  config.after(:all, :search => :true) do
   tire_off
  end


end


# See config.after(:all,:setup => true)
# With this you can define a setup block in a describe block that gets cleaned after all specs in this block
def setup
    DatabaseCleaner.start
    DatabaseCleaner.strategy = nil
end





