#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

ENV["RAILS_ENV"] = "test"

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new [
SimpleCov::Formatter::HTMLFormatter,
Coveralls::SimpleCov::Formatter
]

SimpleCov.start 'rails' do
  add_filter "lib/tasks/*"
  add_filter "app/models/statistic.rb" #only backend
  add_filter "app/helpers/statistic_helper.rb" #only backend
  add_filter "lib/autoload/sidekiq_redis_connection_wrapper.rb" #util-class
  add_filter "lib/autoload/paperclip_orphan_file_cleaner.rb" #part of rake task
  #reference implementations
  add_filter "lib/autoload/paypal_ipn.rb"
  add_filter "lib/autoload/single_sign_on.rb"
  minimum_coverage 90
end

require File.expand_path("../../config/environment", __FILE__)

require "rails/test_help"
require "mocha/minitest"

require 'sidekiq/testing'
require 'fakeredis'
require "savon/mock/spec_helper"
require 'webmock/minitest'
require 'bcrypt'

# Webmock
WebMock.allow_net_connect!

# Fake services
Dir[Rails.root.join("test/support/fake_services/*.rb")].each {|f| require f}

# First matchers, then modules, then helpers. Helpers need to come after modules due to interdependencies.
Dir[Rails.root.join("test/support/modules/*.rb")].each {|f| require f}
Dir[Rails.root.join("test/support/spec_helpers/*.rb")].each {|f| require f}

# For Sidekiq
Sidekiq::Testing.inline!

# Redis
Redis.current = Redis.new

# Secret Token 4 testing:
Fairmondo::Application.config.secret_token = '599e6eed15b557a8d7fdee1672761277a174a6a7e3e8987876d9e6ac685d68005b285b14371e3b29c395e1d64f820fe05eb981496901c2d73b4a1b6c868fd771'

silence_warnings do
  BCrypt::Engine::DEFAULT_COST = BCrypt::Engine::MIN_COST
end

setup_categories

include Savon::SpecHelper
savon.mock!

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  require 'enumerize/integrations/rspec'
  extend Enumerize::Integrations::RSpec

  fixtures :all

  self.use_transactional_tests = true
  before :each do
    # Use fake Fastbill service
    stub_request(:any, /app.monsum.com/).to_rack(FakeFastbill)
  end

  include FactoryBot::Syntax::Methods
  include ActiveSupport::Testing::TimeHelpers
  include ActionDispatch::TestProcess
end
