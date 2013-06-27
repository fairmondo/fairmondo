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
module Article::Search
  extend ActiveSupport::Concern

  included do

    searchable :unless => :template?, :if => :active? do
      text :title, :boost => 5.0, :stored => true
      text :content, :as => "content"
      boolean :fair
      boolean :ecologic
      boolean :small_and_precious
      string :condition
      integer :category_ids, :references => Category, :multiple => true
    end

    # Indexing via Delayed Job Daemon
    handle_asynchronously :solr_index, queue: 'indexing', priority: 50
    handle_asynchronously :solr_index!, queue: 'indexing', priority: 50


    alias_method_chain :remove_from_index, :delayed
    alias :solr_remove_from_index :remove_from_index

  end

  def remove_from_index_with_delayed
    Delayed::Job.enqueue RemoveIndexJob.new(record_class: self.class.to_s, attributes: self.attributes), queue: 'indexing', priority: 50
  end

  def find_like_this page
    Article.search(:include => [:transaction, :seller, :images]) do
      fulltext self.title
      paginate :page => page, :per_page => WillPaginate.per_page
      with :fair, true if self.fair
      with :ecologic, true if self.ecologic
      with :small_and_precious, true if self.small_and_precious
      with :condition, self.condition if self.condition
      with :category_ids, Article::Categories.search_categories(self.categories) if self.categories.present?
    end
  end
end
