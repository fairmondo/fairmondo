#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
module User::State
  extend ActiveSupport::Concern

  included do
    ####################################################
    # State Machine
    #
    ####################################################

    state_machine :seller_state, initial: :standard_seller do
      after_transition any => :bad_seller, do: :send_bad_seller_notification

      event :rate_up do
        transition bad_seller: :standard_seller
      end

      event :rate_down_to_bad_seller do
        transition all => :bad_seller
      end

      event :block do
        transition all => :blocked
      end

      event :unblock do
        transition blocked: :standard_seller
      end
    end

    state_machine :buyer_state, initial: :standard_buyer do
      event :rate_up_buyer do
        transition standard_buyer: :good_buyer, bad_buyer: :standard_buyer
      end

      event :rate_down_to_bad_buyer do
        transition all => :bad_buyer
      end
    end
  end

  def send_bad_seller_notification
    RatingMailer.delay.bad_seller_notification(self)
  end

end
