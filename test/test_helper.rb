ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"
require "minitest/pride"
require "mocha/mini_test"

require 'support/spec_helpers/coverage.rb'

require File.expand_path("../../config/environment", __FILE__)

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require "minitest-matchers"
require 'sidekiq/testing'
require 'fakeredis'
require "savon/mock/spec_helper"

# First matchers, then modules, then helpers. Helpers need to come after modules due to interdependencies.
Dir[Rails.root.join("test/support/matchers/*.rb")].each {|f| require f}
Dir[Rails.root.join("test/support/modules/*.rb")].each {|f| require f}
Dir[Rails.root.join("test/support/spec_helpers/*.rb")].each {|f| require f}

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

TireTest.off
setup_categories

### RSpec Configurations ###

#RSpec.configure do |config|

  ## Configs from presets ##

  #config.fixture_path = "#{::Rails.root}/spec/fixtures"
  #config.use_transactional_fixtures = false # We use Database cleaner for fine grained cleaning levels
  #config.infer_base_class_for_anonymous_controllers = false
  #config.order = "random"
  #config.infer_spec_type_from_file_location!
  #config.raise_errors_for_deprecations!
  ## Custom configs ##

  # Add the "visual" tag to a test that uses save_and_open_page.
  # This will give you the corresponding css and js
#  if config.inclusion_filter[:visual]
#    config.before(scope = :suite) do
#      %x[bundle exec rake assets:precompile]
#    end
#  end

include Savon::SpecHelper
savon.mock!

Minitest.after_run do
  rails_best_practices
  brakeman
end

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  require 'enumerize/integrations/rspec'
  extend Enumerize::Integrations::RSpec

  fixtures :all

end

DatabaseCleaner.strategy = :transaction

class MiniTest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end

  include ::PunditMatcher

  # Add more helper methods to be used by all tests here...
end




