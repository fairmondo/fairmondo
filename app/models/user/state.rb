#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

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
