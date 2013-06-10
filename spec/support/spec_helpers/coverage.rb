#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
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
  puts "\n"

  if $? == 0 && !$suite_failing
    if SimpleCov.result.covered_percent < 100
      puts "Please ensure the code coverage is at 100% before pushing to the Fairnopoly repository.".red.underline
    else
      puts "Perfect! The test suite is passing.".green
    end
  else
    puts "Please take care of the issues described above before pushing to the Fairnopoly repository.".red.underline
  end
  puts "\n"
end
