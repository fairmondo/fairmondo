#
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
require 'rspec/autorun'
require 'capybara/rspec'

# Requires supporting ruby files:
require 'support/spec_helpers/final.rb' # ensure this is the last rspec after-suite
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
    $suite_failing = false # tracks issues over additional audits
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
