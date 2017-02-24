#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

begin
  # Loading seller_constants.yml
  seller_constants = YAML.load(File.read(File.expand_path(File.join( Rails.root, 'config', 'seller_constants.yml'))))
  PRIVATE_SELLER_CONSTANTS    = seller_constants['private_seller_constants']
  COMMERCIAL_SELLER_CONSTANTS = seller_constants['commercial_seller_constants']


rescue
  puts 'seller_constants.yml not found'
end
