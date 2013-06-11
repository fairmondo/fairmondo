#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class ArticlePolicy < Struct.new(:user, :article)

  def index?
    true
  end

  def show?
    article.active || (user && own?)
  end

  def new?
    create?
  end

  def create?
    true # Devise already ensured this user is logged in.
  end

  def edit?
    update?
  end

  def update?
    own? && article.preview?
  end

  def destroy?
    update? # only soft delete
  end

  def activate?
    user && own? && !article.active
  end

  def deactivate?
     user && own? && article.active
  end

  def report?
    user && !own?
  end

  private
  def own?
    user.id == article.seller.id
  end

  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.where(:active => true)
    end
  end
end
