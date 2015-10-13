#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class LineItemGroupPolicy < Struct.new(:user, :line_item_group)
  def show?
    # XOR!!!
    user.is?(line_item_group.buyer) || user.is?(line_item_group.seller)
  end
end
