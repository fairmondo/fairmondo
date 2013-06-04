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
module Article::State
  extend ActiveSupport::Concern

  included do
    # market place state
    attr_protected :state, :active

    state_machine :initial => :preview do

      state :preview do
        def active
          false
        end
      end

      state :active do
        def active
          true
        end
      end

      state :locked do
        def active
          false
        end
      end

      event :activate do
        transition [:preview,:locked] => :active
      end

      event :deactivate do
        transition :active => :locked
      end

      after_transition :on => :activate, :do => :calculate_fees_and_donations

    end

  end

end
