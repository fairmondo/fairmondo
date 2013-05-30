#
# Farinopoly - Fairnopoly is an open-source online marketplace soloution.
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
# Check for n+1 queries and other slow stuff
RSpec.configure do |config|
  $bullet_log = "#{Rails.root.to_s}/log/bullet.log"

  config.before :suite do
    # Empty out the bullet log
    File.open($bullet_log, 'w') {|f| f.truncate(0) }
  end

  config.after :suite do
    unless $skip_audits
      puts "\n\n[Bullet] Checking for performance drains:\n".underline
      bullet_warnings = File.open($bullet_log, "rb").read

      if bullet_warnings.empty?
        puts "No issues found. Very good.".green
      else
        puts bullet_warnings.yellow
        puts "Please deal with these issues before pushing.".red.underline
      end
    end
  end
end
