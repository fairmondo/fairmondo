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
class BestPracticesIndex < ActiveRecord::Migration
  def change
     add_index :articles, :article_template_id unless index_exists? :articles, :article_template_id
     add_index :article_templates, :user_id
     add_index :articles, :user_id
     add_index :articles, :transaction_id
     add_index :bids, :user_id
     add_index :categories, :parent_id
     add_index :fair_trust_questionnaires, :article_id
     add_index :libraries, :user_id
     add_index :library_elements, :library_id
     add_index :library_elements, :article_id
     add_index :social_producer_questionnaires, :article_id
  end
end