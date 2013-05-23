### SimpleCOV ###

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start 'rails' do
  add_filter "app/mailers/notification.rb"
  add_filter "gems/*"
  add_filter "app/mailers/notification.rb"
  minimum_coverage 100
end

SimpleCov.at_exit do
  SimpleCov.result.format!
  if SimpleCov.result.covered_percent < 100
    # puts "\033[0;31mPlease ensure the code coverage is at 100% before pushing!\033[0m"
    puts "Please ensure the code coverage is at 100% before pushing.".red.underline
  end
end