#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class LibraryPolicy < Struct.new(:user, :library)
  def create?
    own?
  end

  def update?
    own? || admin?
  end

  def destroy?
    own?
  end

  def show?
    library.public? || own? || admin?
  end

  def admin_add?
    admin?
  end

  def admin_remove?
    admin?
  end

  def admin_audit?
    admin?
  end

  private

  def own?
    user && user.id == library.user_id
  end

  def admin?
    User.is_admin? user
  end

  class Scope < Struct.new(:current_user, :user, :scope)
    def resolve
      included_scope = scope.includes(comments: [:user, :commentable])

      if user && (user.is? current_user)
        included_scope
      else
        included_scope.published.not_empty
      end
    end
  end
end
