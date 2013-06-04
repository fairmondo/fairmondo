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
class CreateSocialProducerQuestionnaire < ActiveRecord::Migration
  def up
    create_table :social_producer_questionnaires do |t|
      t.integer :auction_id

      t.boolean :nonprofit_association, :default => true
      t.text :nonprofit_association_purposes

      t.boolean :social_businesses_muhammad_yunus, :default => true
      t.text :social_businesses_muhammad_yunus_purposes

      t.boolean :social_entrepreneur, :default => true
      t.text :social_entrepreneur_purposes
    end
  end

  def down
    drop_table :social_producer_questionnaires
  end
end
