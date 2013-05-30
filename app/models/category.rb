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
class Category < ActiveRecord::Base

  attr_accessible :name, :parent, :desc, :parent_id

  has_and_belongs_to_many :articles

  belongs_to :parent , :class_name => 'Category'

  # Doesn't work with our category tree
  #validates :name, :uniqueness => true

  acts_as_nested_set

  # recursively determines whether the passed collection includes all ancestors of self
  # without hitting the db
  def include_all_ancestors?(categories)
    categories = categories.all unless categories.is_a?(Array)
    return true unless parent_id
    p = categories.select{|c| c.id == self.parent_id}.first
    if p
      p.include_all_ancestors?(categories)
    else
      false
    end
  end

  def self_and_ancestors_ids

    self_and_ancestors = [ self.id ]
    self.ancestors.each do |ancestor|
      self_and_ancestors << ancestor.id
    end
    self_and_ancestors
  end

end