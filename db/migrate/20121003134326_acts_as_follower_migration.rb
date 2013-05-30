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
class ActsAsFollowerMigration < ActiveRecord::Migration
  def self.up
    create_table :follows, :force => true do |t|
      t.references :followable, :polymorphic => true, :null => false
      t.references :follower,   :polymorphic => true, :null => false
      t.boolean :blocked, :default => false, :null => false
      t.timestamps
    end

    add_index :follows, ["follower_id", "follower_type"],     :name => "fk_follows"
    add_index :follows, ["followable_id", "followable_type"], :name => "fk_followables"
  end

  def self.down
    drop_table :follows
  end
end