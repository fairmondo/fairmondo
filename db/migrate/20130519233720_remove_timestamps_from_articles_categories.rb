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
class RemoveTimestampsFromArticlesCategories < ActiveRecord::Migration
  def up
    remove_index :articles_categories, :column => ["article_id", "category_id"]
    remove_column :articles_categories, :created_at
    remove_column :articles_categories, :updated_at
    add_index :articles_categories, ["article_id", "category_id"] , :name => "articles_category_index"
    #index name too long sqlite
  end

  def down
    add_column :articles_categories, :updated_at, :string
    add_column :articles_categories, :created_at, :string
  end
end
