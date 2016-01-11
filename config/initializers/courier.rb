#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

begin
  courier = {}
  if Rails.env == 'production'
    courier = YAML.load(File.read('/var/www/fairnopoly/shared/config/courier.yml'))
  else
    courier = YAML.load(File.read(File.expand_path(File.join(Rails.root, 'config', 'courier.yml'))))
  end
  COURIER = courier['courier']

rescue
  puts 'courier.yml not found'
end
