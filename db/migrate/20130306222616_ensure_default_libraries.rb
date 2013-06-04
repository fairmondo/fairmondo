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
class EnsureDefaultLibraries < ActiveRecord::Migration
  class User < ActiveRecord::Base
    has_many :libraries
    def create_default_library
      if self.libraries.empty?
        # Library.create(:name => I18n.t('library.default'),:public => false, :user_id => self.id) uncommented because its dirty and it was already run on server
      end
    end
  end
  class Library < ActiveRecord::Base
    belongs_to :user
    attr_accessible :name
  end
  def up
    User.reset_column_information
    Library.reset_column_information
    User.all.each do |user|
      user.create_default_library
    end
  end

  def down
    #not needed ... cant harm
  end
end
