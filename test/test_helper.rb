#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"
require "minitest/pride"
require "mocha/mini_test"
require 'capybara/rails'
require Rails.root.join('test/support/spec_helpers/coverage.rb')

require File.expand_path("../../config/environment", __FILE__)

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require "minitest-matchers"
require 'minitest/hell'
require 'sidekiq/testing'
#require 'pry-rescue/minitest' if ENV['RESCUE']
require 'fakeredis'
require "savon/mock/spec_helper"
require 'webmock/minitest'
require 'bcrypt'

# Webmock
WebMock.allow_net_connect!

# Fake services
Dir[Rails.root.join("test/support/fake_services/*.rb")].each {|f| require f}

# First matchers, then modules, then helpers. Helpers need to come after modules due to interdependencies.
Dir[Rails.root.join("test/support/matchers/*.rb")].each {|f| require f}
Dir[Rails.root.join("test/support/modules/*.rb")].each {|f| require f}
Dir[Rails.root.join("test/support/spec_helpers/*.rb")].each {|f| require f}

# For Sidekiq
Sidekiq::Testing.inline!

# Redis
Redis.current = Redis.new
Capybara.asset_host = "http://localhost:3000"

# For fixtures:
include ActionDispatch::TestProcess

# Secret Token 4 testing:
Fairmondo::Application.config.secret_token = '599e6eed15b557a8d7fdee1672761277a174a6a7e3e8987876d9e6ac685d68005b285b14371e3b29c395e1d64f820fe05eb981496901c2d73b4a1b6c868fd771'

#~Disable logging for test performance! Change this value if you really need the log and run your suite again~
Rails.logger.level = 4

### Test Setup ###
File.open(Rails.root.join('log/test.log'), 'w') {|f| f.truncate(0) } # clear test log


silence_warnings do
  BCrypt::Engine::DEFAULT_COST = BCrypt::Engine::MIN_COST
end

setup_categories

include Savon::SpecHelper
savon.mock!

Minitest.after_run do
  if $suite_passing &&
    # Don't run these if individual tests are run (TEST=tests/models/xxx_test.rb)
    ENV['TEST'].blank?
    rails_best_practices
    brakeman
    rubocop # TODO: uncomment and fix rubocop violations
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  require 'enumerize/integrations/rspec'
  extend Enumerize::Integrations::RSpec

  fixtures :all

  before :each do
    DatabaseCleaner.start

    # Use fake Fastbill service
    stub_request(:any, /app.monsum.com/).to_rack(FakeFastbill)
  end

  after :each do
    DatabaseCleaner.clean

    $suite_passing = false if failure
  end

  # Add more helper methods to be used by all tests here...
  include FactoryGirl::Syntax::Methods
end

class MiniTest::Spec
  before :each do
    DatabaseCleaner.start

    # Use fake Fastbill service
    stub_request(:any, /app.monsum.com/).to_rack(FakeFastbill)
  end

  after :each do
    DatabaseCleaner.clean

    $suite_passing = false if failure
  end

  # Add more helper methods to be used by all tests here...
  include FactoryGirl::Syntax::Methods
  include ActiveSupport::Testing::TimeHelpers
end

$suite_passing = true

DatabaseCleaner.strategy = :transaction
