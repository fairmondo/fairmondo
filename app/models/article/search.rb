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

    attr_accessor :search_in_content, :search_for_zip, :search_order_by

    def search_in_content= value
      if value == "1"
        @search_in_content = true
      else
        @search_in_content = false
      end
    end

    enumerize :search_order_by, in: [:newest,:cheapest,:most_expensive,:old,:new,:fair,:ecologic,:small_and_precious,:most_donated] #   => :newest,"Preis aufsteigend" => :cheapest,"Preis absteigend" => :most_expensive

    alias :search_in_content? :search_in_content

    def self.search_attrs
      [:search_in_content,:search_for_zip,:search_order_by]
    end

  end



 def find_like_this page
    query = self
    fields = [:title, :friendly_percent_organisation_nickname, :gtin]
    fields << :content if query.search_in_content
    articles = Article.search(:page => page) do
      if query.title && !query.title.empty?
        query do
          match fields, query.title
        end
      end
      filter :term, :fair => true if query.fair
      filter :term, :ecologic => true if query.ecologic
      filter :term, :small_and_precious => true  if query.small_and_precious
      filter :term, :condition => query.condition  if query.condition
      filter :terms, :categories => Article::Categories.search_categories(query.categories) if query.categories.present?
      filter :term, :zip => query.search_for_zip if query.search_for_zip.present?

      case query.search_order_by
      when "newest"
        sort { by :created_at, :desc  }
      when "cheapest"
        sort { by :price_cents, :asc }
      when "most_expensive"
        sort { by :price_cents, :desc }
      when "old"
        sort { by :condition, :desc }
      when "new"
        sort { by :condition, :asc }
      when "fair"
        sort { by :fair, :desc }
      when "ecologic"
        sort { by :ecologic, :desc }
      when "small_and_precious"
        sort { by :small_and_precious, :desc }
      when "most_donated"
        sort { by :friendly_percent, :desc }
      else
        sort { by :created_at, :desc }
      end
    end
  end

  # Index the zip for sellers
  def zip
    #only for products which have pickup transport
    if self.transport_pickup
      self.seller.zip
    else
      nil
    end
  end




end
