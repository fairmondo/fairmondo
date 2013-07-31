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
role :app, "78.109.61.168", :primary => true
role :app, "78.109.61.169"
role :web, "78.109.61.168", :primary => true
role :web, "78.109.61.169"
role :db, "78.109.61.168", :primary => true

set :rails_env, "production"
set :branch, "release"
<<<<<<< HEAD


namespace :content  do
  desc "Import content"
  task :import, :roles => :db do
    upload "#{ARGV[2]}", "#{shared_path}/content_import.csv"
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake content:import #{shared_path}/content_import.csv"
  end
end
=======
>>>>>>> e93e0bbe7abb92abde275e625291418406736db6
