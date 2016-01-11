#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class LineItemPolicy < Struct.new(:user, :line_item)
  def create?
    article_active?
  end

  def update?
    destroy?
  end

  def destroy?
    line_item.cart_id == line_item.cart_cookie || user == line_item.cart.user
  end

  private

  def article_active?
    line_item.article && line_item.article.active?
  end
end
