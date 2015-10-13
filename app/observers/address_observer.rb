#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

# See http://rails-bestpractices.com/posts/19-use-observer

class AddressObserver < ActiveRecord::Observer
  def after_save(address)
    address.user.update_column(:standard_address_id, address.id) if address.set_as_standard_address
  end
end
