#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class PaymentPolicyTest < ActiveSupport::TestCase
  include PunditMatcher

  let(:lig) { payment.line_item_group }
  let(:payment) { build(:paypal_payment) }

  describe 'for a visitor' do
    let(:user) { nil }
    it { refute_permit(user, payment, :show) }
    it { refute_permit(user, payment, :create) }
  end

  describe 'for a random logged-in user' do
    let(:user) { create :user }
    it { refute_permit(user, payment, :show) }
    it { refute_permit(user, payment, :create) }
  end

  describe 'for the buying user' do
    let(:user) { payment.line_item_group_buyer }
    it { assert_permit(user, payment, :show) }
    it { assert_permit(user, payment, :create) }
  end
end
