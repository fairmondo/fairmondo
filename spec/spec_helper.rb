ENV["RAILS_ENV"] ||= 'test'

### General Requires ###

require 'support/spec_helpers/coverage.rb'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'

# Requires supporting ruby files:
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# For starting the solr engine:
require 'sunspot_test/rspec'

# For fixtures:
include ActionDispatch::TestProcess
require Rails.root.join('db/fixtures/category_seed_data.rb')



### Settings ###

Delayed::Worker.delay_jobs = false

# Secret Token 4 testing:
Fairnopoly::Application.config.secret_token = '599e6eed15b557a8d7fdee1672761277a174a6a7e3e8987876d9e6ac685d68005b285b14371e3b29c395e1d64f820fe05eb981496901c2d73b4a1b6c868fd771'



### Test Setup ###

File.open(Rails.root.join('log/test.log'), 'w') {|f| f.truncate(0) } # clear test log


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

  config.before :suite do
    $skip_audits = true # Variable is needed when a test fails and the other audits don't need to be run
    puts "\n[Rspec] Specifications:\n".underline
  end

  config.after :suite do
    %x[ code-cleaner . ]

    if RSpec.configuration.reporter.instance_variable_get(:@failure_count) > 0
      puts "\n\nErrors occured. Not running additional tests.".red
    else
      $skip_audits = false
    end
  end
end
