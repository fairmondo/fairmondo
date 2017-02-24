#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

# This is a helper that is supposed to be extended by all single table inheritance subclasses.
module STI
  # See http://stackoverflow.com/questions/6146317/is-subclassing-a-user-model-really-bad-to-do-in-rails
  #
  # @api public
  # @return [String] The parent's model_name
  delegate :model_name, to: :superclass
end
