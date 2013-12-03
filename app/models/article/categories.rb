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
module Article::Categories
  extend ActiveSupport::Concern

  included do
    def self.category_attrs
      [categories_and_ancestors: []]
    end
    #! attr_accessible :categories_and_ancestors, :category_proposal
    attr_accessor :category_proposal

    # categories refs #154
    has_and_belongs_to_many :categories

    validates :categories, :size => {
      :in => 1..2,
      :add_errors_to => [:categories, :categories_and_ancestors]
    }
    before_validation :ensure_no_redundant_categories # just store the leafs to avoid inconsistencies
  end

  def categories_and_ancestors
    @categories_and_ancestors ||= (categories && categories.map(&:self_and_ancestors).flatten.uniq) || []
  end

  def categories_and_ancestors=(categories)
    if categories.first.is_a?(String) || categories.first.is_a?(Integer)
      categories = categories.select(&:present?).map(&:to_i)
      categories = Category.where(:id => categories)
    end

    # remove all parents
    self.categories = Article::Categories.remove_category_parents(categories)
  end

  def self.remove_category_parents(categories)
    # does not hit the database
    categories.reject{|c| categories.any? {|other| c!=nil && other.is_descendant_of?(c) } }
  end


  def ensure_no_redundant_categories
    self.categories = Article::Categories.remove_category_parents(self.categories) if self.categories
    true
  end
  private :ensure_no_redundant_categories

  # For Solr searching we need category ids
  def self.search_categories(categories)
    ids = []
    categories = Article::Categories.remove_category_parents(categories)

    categories.each do |category|
     category.self_and_descendants.each do |fullcategories|
        ids << fullcategories.id
      end
    end
    ids
  end

  # Only allow categories that are not "Other"
  def self.specific_search_categories(categories)

    ids = self.search_categories(categories)
    other = Category.other_category
    ids.map! { |id| id == other.id ? 0 : id} if other  #set the other category to 0 because solr throws exceptions if categories are empty
    ids
  end


end
