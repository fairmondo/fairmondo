#
#
# == License:
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
  add_filter "app/jobs/process_mass_upload_job.rb"
  add_filter "app/helpers/statistics_helper.rb"
  add_filter "lib/autoload/sidekiq_redis_connection_wrapper.rb"
  minimum_coverage 100
end


SimpleCov.at_exit do
  if ParallelTests.first_process?
    ParallelTests.wait_for_other_processes_to_finish
    puts "\n\n[SimpleCov] Generating coverage report:\n".underline
    SimpleCov.result.format!
    puts "\n"

    if $? == 0 && !$suite_failing
      if SimpleCov.result.covered_percent < 100
        puts "Please ensure the code coverage is at 100% before pushing to the Fairnopoly repository.".red.underline
        puts "Note: Code coverage isn't accurately calculated if you ran this with parallel_test or only ran part of the test suite.".yellow
      else
        puts "Perfect! The test suite is passing.".green
      end
    else
      puts "Please take care of the issues described above before pushing to the Fairnopoly repository.".red.underline
    end
    final_after_hook # because this tends to be the hook that runs naturally last
  end
end
