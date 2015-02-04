#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
class MassUploadPolicy < Struct.new(:user, :mass_upload)

  def show?
    (mass_upload.finished? || mass_upload.activated?) && own?
  end

  def new?
    create?
  end

  def create?
    user.is_a? LegalEntity # TODO Use Article policy
  end

  def update?
    own? && create?
  end

  private
    def own?
      user.id == mass_upload.user.id
    end
end
