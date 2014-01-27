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
role :app, "78.109.61.168", :primary => true
role :app, "78.109.61.169"
role :app, "78.109.59.254"
role :web, "78.109.61.168", :primary => true
role :web, "78.109.61.169"
role :web, "78.109.59.254"
role :db, "78.109.61.168", :primary => true
role :sidekiq, "5.22.150.182"

set(:sidekiq_processes) { 2 }


set :rails_env, "production"
set :branch, fetch(:branch, "master")

