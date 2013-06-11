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
class RenameLegalEntityToType < ActiveRecord::Migration

  class User < ActiveRecord::Base

  end

  def up
    add_column :users , :type , :string
    User.reset_column_information
    User.all.each do |user|
      if user.legal_entity?
        user.type = "LegalEntity"
      else
        user.type = "PrivateUser"
      end
      user.save!
    end
    remove_column :users , :legal_entity
  end

  def down
     add_column:users , :legal_entity, :boolean
     User.reset_column_information
      User.all.each do |user|
        if user.type=="LegalEntity"
          user.legal_entity = true
        else
          user.legal_entity = false
        end
        user.save!
      end
     remove_column :users , :type
  end
end
