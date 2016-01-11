#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ContentPolicy < Struct.new(:user, :category)
  def index?
    admin?
  end

  def show?
    true
  end

  def new?
    admin?
  end

  def edit?
    admin?
  end

  def create?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def not_found? # ?
    true
  end

  def admin?
    User.is_admin? user
  end
end
