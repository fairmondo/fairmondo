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

    attr_accessor :category_proposal

    # categories refs #154
    has_and_belongs_to_many :categories

    validates :categories, :size => {
      :in => 1..2,
      :add_errors_to => [:categories, :category_ids]
    }
    before_validation :ensure_no_redundant_categories # just store the leafs to avoid inconsistencies
  end

  def category_ids= category_ids
    self.categories = []
    category_ids.each do |category_id|
      if category_id.to_s.match(/\A\d+\Z/)
        self.categories << Category.find(category_id.to_i)
      end
    end
  end


  def ensure_no_redundant_categories
    self.category_ids =  categories.reject{|c| categories.any? {|other| c!=nil && other.is_descendant_of?(c) } }.uniq{|c| c.id}.map(&:id) if self.categories
    true
  end
  private :ensure_no_redundant_categories

end
