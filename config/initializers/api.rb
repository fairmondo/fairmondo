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
  # Loading api.yml
  api = YAML.load(File.read(File.expand_path(File.join( Rails.root, 'config', 'api.yml'))))
rescue
  puts 'api.yml not found'
end

begin
  # recaptcha-api
  Recaptcha.configure do |config|
    config.public_key  = api['recaptcha']['public']
    config.private_key = api['recaptcha']['private']
  end
rescue
  puts "Recaptcha API key(s) couldn't be found."
end

begin
  # konto-api
  KontoAPI::api_key = api['kontoapi']['key']
  KontoAPI::timeout = 10
rescue
  puts "KontoAPI key couldn't be found."
end

begin
  # FastBill Automatic API
  Fastbill::Automatic.api_key = api['fastbill']['api_key']
  Fastbill::Automatic.email   = api['fastbill']['email']
rescue
  puts "FastBill API key(s) couldn't be found."
end

begin
  # Cleverreach API
  CleverreachAPI::API_KEY = api['cleverreach']['key']
  CleverreachAPI::LIST_ID = api['cleverreach']['list']
rescue
  puts "Cleverreach API key(s) couldn't be found."
end
