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
begin
  # Loading seller_constants.yml
  seller_constants = YAML.load(File.read(File.expand_path(File.join( Rails.root, 'config', 'seller_constants.yml'))))
  $private_seller_constants  = seller_constants['private_seller_constants']
  $commercial_seller_constants  = seller_constants['commercial_seller_constants']


rescue
  puts 'seller_constants.yml not found'
end
