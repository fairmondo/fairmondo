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
module Article::Search
  extend ActiveSupport::Concern

  included do

    attr_accessor :contentsearch

    def search_in_content= bool
      if bool == "1"
        self.contentsearch= true
      else
        self.contentsearch= false
      end
    end

    def search_in_content
      self.contentsearch
    end

    def self.search_attrs
      [:search_in_content]
    end

    searchable :unless => :template?, :if => :active? do
      text :title, :boost => 5.0, :stored => true
      text :title, :as => 'title_text_ngram', :stored => true
      text :content

      # filters
      boolean :fair
      boolean :ecologic
      boolean :small_and_precious
      string :condition

      # for category filters
      integer :category_ids, :references => Category, :multiple => true

      # for sorting
      time :created_at

      # don't hit AR and store fields in solr
      string :title_image, :using => :title_image_thumb_path, :stored => true
      integer :price_cents, :stored => true
      integer :basic_price_cents, :stored => true
      integer :basic_price_amount, :stored => true
      integer :vat, :stored => true

      # Possible future local search

      boolean :transport_pickup
      string :zip
    end

    # Indexing via Delayed Job Daemon
    handle_asynchronously :solr_index, queue: 'indexing', priority: 50
    handle_asynchronously :solr_index!, queue: 'indexing', priority: 50


    alias_method_chain :remove_from_index, :delayed
    alias :solr_remove_from_index :remove_from_index

  end

  def title_image_thumb_path
     title_image.image(:thumb) if title_image
  end

  def remove_from_index_with_delayed
    Delayed::Job.enqueue RemoveIndexJob.new(record_class: self.class.to_s, attributes: self.attributes), queue: 'indexing', priority: 50
  end

  def find_like_this page
    Article.search(:include => [:seller, :images]) do
      fulltext self.title
      paginate :page => page, :per_page => Kaminari.config.default_per_page
      with :fair, true if self.fair
      with :ecologic, true if self.ecologic
      with :small_and_precious, true if self.small_and_precious
      with :condition, self.condition if self.condition
      with :category_ids, Article::Categories.search_categories(self.categories) if self.categories.present?
      order_by(:created_at, :desc)
    end
  end

  def zip
    self.seller.zip
  end


end
