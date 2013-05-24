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
  add_filter "lib/tasks/*"
  minimum_coverage 100
end

SimpleCov.at_exit do
  puts "\n\n[SimpleCov] Generating coverage report:\n".underline
  SimpleCov.result.format!

  puts "Please ensure the code coverage is at 100% before pushing.".red.underline if SimpleCov.result.covered_percent < 100
end