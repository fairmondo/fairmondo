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
      end

      state :active do
      end

      state :locked do
      end

      state :closed do
      end

      event :activate do
        transition [:preview,:locked] => :active
      end

      event :deactivate do
        transition :active => :locked
      end

      event :close do
        transition :locked => :closed
      end

      after_transition :on => :activate, :do => :calculate_fees_and_donations

    end

  end

end
