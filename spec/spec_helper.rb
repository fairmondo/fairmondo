require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  require 'simplecov'
  
  SimpleCov.start 'rails' do
    add_filter "app/mailers/notification.rb"
    add_filter "gems/*"
  end
  
  ENV["RAILS_ENV"] ||= 'test'
  
  begin
    # if we are on spork we need to do this
    
    Spork.trap_method(Rails::Application::RoutesReloader, :reload!)
  
    # Prevent main application to eager_load in the prefork block (do not load files in autoload_paths)
    Spork.trap_method(Rails::Application, :eager_load!)
  rescue
    # spork not up
  end
  
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/rspec'
  require Rails.root.join('db/fixtures/category_seed_data.rb')
  
  require 'sunspot_test/rspec' # for starting the solr engine
  
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  
  Delayed::Worker.delay_jobs = false
  
  #Secret Token 4 testing:
  Fairnopoly::Application.config.secret_token = '599e6eed15b557a8d7fdee1672761277a174a6a7e3e8987876d9e6ac685d68005b285b14371e3b29c395e1d64f820fe05eb981496901c2d73b4a1b6c868fd771'
  
  
  
  RSpec.configure do |config|
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
  
   
 
    
    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
  
    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true
  
    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false
  
    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"
  end

end

Spork.each_run do
  # This code will be run each time you run your specs.
  ActiveSupport::Dependencies.clear
  ActiveRecord::Base.instantiate_observers
  FactoryGirl.reload

  Dir[File.join(File.dirname(__FILE__), '..', 'app', 'helpers', '*.rb')].each do |file|
    require file
  end
end





