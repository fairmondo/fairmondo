#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class CategoryPolicy < Struct.new(:user, :category)
  def show?
    true
  end

  def select_category?
    true
  end
end
