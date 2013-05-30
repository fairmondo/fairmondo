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
class RenameDependencies < ActiveRecord::Migration
  def change
    rename_column :articles, :auction_template_id, :article_template_id
    rename_column :articles_categories, :auction_id, :article_id
    rename_column :fair_trust_questionnaires, :auction_id, :article_id
    rename_column :images, :auction_id, :article_id
    rename_column :library_elements, :auction_id, :article_id
    rename_column :social_producer_questionnaires, :auction_id, :article_id
    rename_index :articles, 'index_auctions_on_auction_template_id', 'index_articles_on_article_template_id'
    rename_index :articles, 'index_auctions_on_id_and_auction_template_id','index_articles_on_id_and_article_template_id'
    rename_index :articles, 'index_auctions_on_slug', 'index_articles_on_slug'
    rename_index :articles_categories, 'index_auctions_categories_on_auction_id_and_category_id' , 'index_articles_categories_on_article_id_and_category_id'
    rename_index :articles_categories, 'index_auctions_categories_on_auction_id', 'index_articles_categories_on_article_id'
    rename_index :articles_categories, 'index_auctions_categories_on_category_id', 'index_articles_categories_on_category_id'
  end





end
