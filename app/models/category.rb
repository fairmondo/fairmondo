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

  attr_accessible :name, :parent, :desc, :parent_id
  attr_accessible :name, :parent, :desc, :parent_id, :created_at, :updated_at, :lft, :rgt, :depth, as: :admin

  has_and_belongs_to_many :articles

  belongs_to :parent , :class_name => 'Category'

  # Doesn't work with our category tree
  #validates :name, :uniqueness => true

  acts_as_nested_set

  # Ensure no n+1 queries result from Category.roots
  scope :roots , includes(:children).roots


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
    other = self.find_by_name("Sonstiges") #internationalize!
    roots = self.order(:name).roots

    if roots.include? other
      roots.delete_at roots.index other
      roots.push(other)
    end
    roots
  end

end
