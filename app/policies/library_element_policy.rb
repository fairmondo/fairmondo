#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class LibraryElementPolicy < Struct.new(:user, :library_element)
  def show?
    active?
  end

  def create?
    own? && active? && user.libraries.count != 0
  end

  def destroy?
    own?
  end

  private

  def own?
    user && user.id == library_element.library_user_id
  end

  def active?
    library_element.article_reduced && library_element.article_reduced.active?
  end
end
