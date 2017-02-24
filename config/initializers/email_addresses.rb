#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

begin

  addresses = YAML.load(File.read(File.expand_path(File.join( Rails.root, 'config', 'email_addresses.yml'))))
  EMAIL_ADDRESSES  = addresses['Addresses']

rescue
  begin
    puts 'email_addresses.yml not found. Try to Load email_addresses.yml.example'
    addresses = YAML.load(File.read(File.expand_path(File.join( Rails.root, 'config', 'email_addresses.yml.example'))))
    EMAIL_ADDRESSES  = addresses['Addresses']
  rescue
    puts 'Not possible to load any email_addresses config!'
  end

end
