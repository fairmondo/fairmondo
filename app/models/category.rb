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
  extend FriendlyId
  friendly_id :name, :use => :slugged

  attr_protected :lft, :rgt, :depth, as: :admin

  has_and_belongs_to_many :articles
  has_and_belongs_to_many :active_articles, :class_name => 'Article', :conditions => {:state => "active"}
  # There is no possible way to keep a counter cache here

  belongs_to :parent , :class_name => 'Category', :counter_cache => :children_count

  delegate :name, to: :parent, prefix: true

  scope :all_by_id, order("id ASC")
  scope :other_category_last, order("CASE WHEN name = 'Sonstiges' THEN 1 ELSE 0 END") #internationalize!
  scope :weighted, order("weight IS NULL, weight desc")
  scope :sorted, order(:name)
  scope :roots, where(parent_id: nil)
  scope :other_category, where(parent_id: nil, name: 'Sonstiges') #internationalize!

  acts_as_nested_set

  def children_with_active_articles
    delete_if_no_active_articles self.children.includes(:children)
  end
  def siblings_with_active_articles #filter = nil
    siblings = self.siblings.except(:order).other_category_last.sorted.includes(:children)
    #siblings = siblings.send filter if filter
    delete_if_no_active_articles siblings
  end
  private
    def delete_if_no_active_articles array
      array.delete_if { |node| node.children.empty? && node.active_articles.empty? }
    end
end
