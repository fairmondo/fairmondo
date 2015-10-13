#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

begin
  # Loading Exceptions
  EXCEPTIONS_ON_FAIRMONDO = YAML.load(File.read(File.expand_path(File.join( Rails.root, 'config', 'exceptions.yml'))))

rescue
  puts 'exceptions.yml not found'
end


