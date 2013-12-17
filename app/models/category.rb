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
class Category < ActiveRecord::Base

  def self.category_attrs
    [:name, :parent, :desc, :parent_id]
  end

  attr_protected :lft, :rgt, :depth, as: :admin
  #! attr_accessible :name, :parent, :desc, :parent_id
  #! attr_accessible :name, :parent, :desc, :parent_id, :article_ids, :child_ids, :created_at, :updated_at, as: :admin

  has_and_belongs_to_many :articles
  has_and_belongs_to_many :active_articles, :class_name => 'Article', :conditions => {:state => "active"}
  # There is no possible way to keep a counter cache here

  belongs_to :parent , :class_name => 'Category', :counter_cache => :children_count

  scope :all_by_id, order("id ASC")

  acts_as_nested_set

  def self_and_ancestors_ids
    self_and_ancestors = [ self.id ]
    self.ancestors.each do |ancestor|
      self_and_ancestors << ancestor.id
    end
    self_and_ancestors
  end

  # Display all categories, sorted by name, other being last
  # @api public
  # @return [Array]
  def self.sorted_roots
    other = self.other_category
    roots = self.order(:name).where(:parent_id => nil)

    if roots.include? other
      roots.delete_at roots.index other
      roots.push(other)
    end
    roots
  end

  def self.other_category
     self.where(:parent_id => nil).find_by_name("Sonstiges") #internationalize!
  end

  def self.find_imported_categories(categories)
    if categories
      self.find_all_by_id(categories.split(",").map { |s| s.to_i })
    end
  end
end
