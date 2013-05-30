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
class ConvertArticleStateToStateMachine < ActiveRecord::Migration
  class Article < ActiveRecord::Base

  end

  def up
    add_column :articles, :state, :string
    Article.reset_column_information
    Article.all.each do |article|
      if article.active && article.locked
        article.state = "active"
      elsif !article.active && article.locked
        article.state = "locked"
      elsif !article.active && !article.locked
        article.state = "preview"
      end
      article.save
    end
    remove_column :articles, :locked

  end

  def down
    add_column :articles,:locked, :boolean
    Article.reset_column_information
    Article.all.each do |article|
      if article.state == "preview"
        article.locked = false
      else
        article.locked = true
      end
      article.save
    end
    remove_column :articles, :state
  end
end
