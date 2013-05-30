#
# Farinopoly - Fairnopoly is an open-source online marketplace soloution.
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
class LibraryPolicy < Struct.new(:user, :library)

  def create?
    own?
  end

  def update?
    own?
  end

  def destroy?
    own?
  end

  private
  def own?
    user.id == library.user_id
  end

  class Scope < Struct.new(:current_user, :user, :scope)
    def resolve
      if current_user.id == user.id
        scope
      else
        scope.public
      end
    end
  end

end
