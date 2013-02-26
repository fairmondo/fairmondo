stage :test_environment do
  action do
    Bundler.require(:test)

    Rails.env = ENV['RAILS_ENV'] = 'test'
    require APP_PATH

    $rails_rake_task = 'yup' # lie to skip eager loading
    Rails.application.require_environment!
    $rails_rake_task = nil

    spec_path = File.join(ROOT_PATH, 'spec')
    $LOAD_PATH.unshift(spec_path) unless $LOAD_PATH.include?(spec_path)
    $LOAD_PATH.unshift(ROOT_PATH) unless $LOAD_PATH.include?(ROOT_PATH)
  end

  stage :spec_helper do
    action { require 'spec_helper' }
    command :rspec do
      exit RSpec::Core::Runner.run(ARGV)
    end
  end
end
