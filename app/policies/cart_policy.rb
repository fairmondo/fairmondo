#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class CartPolicy < Struct.new(:user, :cart)
  def show? cookie_id = nil
    cart.cookie_content ||= cookie_id # to be able to call this method from view
    cart.user ? user == cart.user : cart.id == cart.cookie_content
  end

  def edit?
    update?
  end

  def update?
    user == cart.user
  end

  def empty_cart? cookie_id = nil
    (!user && !cookie_id) || (user && !user.carts.open.any?) || (user && cart.empty?)
  end

  def send_via_email?
    show?
  end
end
