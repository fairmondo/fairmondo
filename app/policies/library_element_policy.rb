#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class LibraryElementPolicy < Struct.new(:user, :library_element)

  def show?
    own? || active?
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
      library_element.article && library_element.article.active?
    end
end
