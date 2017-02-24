#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class PasswordsController < Devise::PasswordsController
  def update
    super

    if current_user.present?
      # TODO: Remove duplicate code in passwords and sessions controllers
      if cart = Cart.find_by_id(cookies.signed[:cart])
        cart.update_attribute :user_id, current_user.id unless cart.user_id
      else # user probably doesn't have cart cookie set
        @current_cart = Cart.current_for current_user
        cookies.signed[:cart] = @current_cart.id if @current_cart
      end
    end
  end
end
