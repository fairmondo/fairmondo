ENV["RAILS_ENV"] ||= 'test'

### General Requires ###

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require Rails.root.join('db/fixtures/category_seed_data.rb')

# For starting the solr engine:
require 'sunspot_test/rspec'

# To run rake tasks:
require 'rake'
Fairnopoly::Application.load_tasks

# For fixture_file_upload:
include ActionDispatch::TestProcess

# Requires supporting ruby files:
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}



### Settings ###

Delayed::Worker.delay_jobs = false

# Secret Token 4 testing:
Fairnopoly::Application.config.secret_token = '599e6eed15b557a8d7fdee1672761277a174a6a7e3e8987876d9e6ac685d68005b285b14371e3b29c395e1d64f820fe05eb981496901c2d73b4a1b6c868fd771'



### RSpec Configurations ###

RSpec.configure do |config|

  ## Configs from presets ##

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
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


  # Additional things we want to test apart from the actual suite #

  config.after :suite do
    # Check for best practices
    bp_analyzer = RailsBestPractices::Analyzer.new(Rails.root, {})
    bp_analyzer.analyze
    bp_analyzer.output
    #bp_analyzer.runner.errors.size.should == 0

    audit_security
  end
end