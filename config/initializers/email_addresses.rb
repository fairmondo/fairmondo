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
begin

  addresses = YAML.load(File.read(File.expand_path(File.join( Rails.root, 'config', 'email_addresses.yml'))))
  $email_addresses  = addresses['Addresses']

rescue
  begin
    puts 'email_addresses.yml not found. Try to Load email_addresses.yml.example'
    addresses = YAML.load(File.read(File.expand_path(File.join( Rails.root, 'config', 'email_addresses.yml.example'))))
    $email_addresses  = addresses['Addresses']
  rescue
    puts 'Not possible to load any email_addresses config!'
  end

end
