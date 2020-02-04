#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class CartPolicyTest < ActiveSupport::TestCase
  include PunditMatcher

  let(:cart) { build :cart }
  let(:user) { nil }

  describe 'for a visitor' do
    it { refute_permit(user, cart, :show)   }
    it { refute_permit(user, cart, :edit)   }
    it { refute_permit(user, cart, :update) }
    it { assert_permit(user, cart, :empty_cart) }
    it { refute_permit(user, cart, :send_via_email) }
  end

  describe 'for a random logged-in user' do
    let(:user) { build :user }
    it { refute_permit(user, cart, :show)   }
    it { refute_permit(user, cart, :edit)   }
    it { refute_permit(user, cart, :update) }
    it { assert_permit(user, cart, :empty_cart) }
    it { refute_permit(user, cart, :send_via_email) }
  end

  describe 'for the owning user' do
    let(:user) { cart.user }
    it { assert_permit(user, cart, :show)   }
    it { assert_permit(user, cart, :edit)   }
    it { assert_permit(user, cart, :update) }
    it { assert_permit(user, cart, :empty_cart) }
    it { assert_permit(user, cart, :send_via_email) }
  end
end
