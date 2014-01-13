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
module Article::State
  extend ActiveSupport::Concern

  included do
    # market place state
    attr_protected :state

    state_machine :initial => :preview do

      state :preview do
        # Inactive and editable
      end

      state :active do
        # Searchable and buyable
      end

      state :locked do
        # Same as preview but not editable
      end

      state :closed do
        # Deleted
      end

      state :sold do
        # Sold
      end

      event :activate do
        transition [:preview,:locked] => :active
      end

      # Theoretical event, can't be performed over state-machine because people with validation issues can't do stuff anymore
      event :deactivate do
        transition :active => :locked
      end

      event :close do
        transition :locked => :closed
      end

      event :sold_out do
        transition :active => :sold
      end

      before_transition :on => :activate, :do => :calculate_fees_and_donations
      after_transition :on => :deactivate, :do => :remove_from_libraries
    end

  end

  def remove_from_libraries
    # delete the article from the collections
    self.library_elements.delete_all
  end

  def deactivate_without_validation
    self.state = "locked"
    self.remove_from_libraries
    self.save(:validate => false) # do it anyways
  end

  def close_without_validation
    self.state = "closed"
    self.save(:validate => false) # do it anyways
  end


end
