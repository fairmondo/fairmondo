#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class StatisticPolicy < Struct.new(:user, :statistic)
  def general?
    admin?
  end

  def category_sales?
    admin?
  end

  private

  def admin?
    User.is_admin? user
  end
end
