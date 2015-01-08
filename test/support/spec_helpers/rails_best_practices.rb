#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
# Check for best practices
def rails_best_practices
  puts "\n\n[RailsBestPractices] Testing:\n"
  bp_analyzer = RailsBestPractices::Analyzer.new(Rails.root)
  bp_analyzer.analyze

  # Console output:
  bp_analyzer.output

  # Generate HTML as well:
  options = bp_analyzer.instance_variable_get :@options
  bp_analyzer.instance_variable_set :@options, options.merge({'format' => 'html'})
  bp_analyzer.output

  exit 1 if bp_analyzer.runner.errors.size > 0
end
