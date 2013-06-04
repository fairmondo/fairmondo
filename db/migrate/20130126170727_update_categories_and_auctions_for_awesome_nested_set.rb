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
class UpdateCategoriesAndAuctionsForAwesomeNestedSet < ActiveRecord::Migration
  class Auction < ActiveRecord::Base

  end
  class AuctionsCategory < ActiveRecord::Base

  end

  def up
    Auction.reset_column_information
    AuctionsCategory.reset_column_information
    Auction.unscoped.all.each do |auction|
      #AuctionsCategory.create(:auction_id => auction.id, :category_id => auction.category_id) uncommented because its dirty and we dont really need this because its already run on server
    end

    add_column :categories, :lft, :integer
    add_column :categories, :rgt, :integer
    add_column :categories, :depth, :integer

    Category.update_all("parent_id = NULL","parent_id = 0")

    Category.rebuild!

    remove_column :auctions, :category_id
    remove_column :auctions, :alt_category_id_1
    remove_column :auctions, :alt_category_id_2
  end

  def down
    Auction.reset_column_information
    AuctionsCategory.reset_column_information
    remove_column :categories, :lft
    remove_column :categories, :rgt
    remove_column :categories, :depth

    add_column :auctions, :category_id, :integer
    add_column :auctions, :alt_category_id_1, :integer
    add_column :auctions, :alt_category_id_2, :integer

    AuctionsCategory.all.each do |auctions_category|
      Auction.unscoped.find(auctions_category.auction_id).update_attribute(:category_id, auctions_category.category_id)
    end
    Category.update_all("parent_id = 0","parent_id IS NULL")
  end
end
