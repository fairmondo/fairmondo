#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

begin
  if Rails.env.production?
    BELBOON_IDS = YAML.load(File.read('/var/www/fairnopoly/shared/config/belboon_trackable_users.yml'))['belboon']['users']
  else
    BELBOON_IDS = YAML.load(File.read(File.expand_path(File.join( Rails.root, 'config', 'belboon_trackable_users.yml'))))['belboon']['users']
  end
rescue
  puts 'belboon_trackable_users.yml not found'
  BELBOON_IDS = []
end
