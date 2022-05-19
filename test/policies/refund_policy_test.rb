#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class RefundPolicyTest < ActiveSupport::TestCase
  include PunditMatcher
  let(:refund) { create :refund }

  describe 'for a visitor' do
    let(:user) { nil }
    it 'should deny refund create for visitors' do
      refute_permit(user, refund, :create)
      refute_permit(user, refund, :new)
    end
  end

  describe 'for a logged in user' do
    describe 'who owns business_transaction' do
      let(:user) { refund.business_transaction_seller }

      describe 'that is sold' do
        describe 'and is not refunded' do
          let(:refund) do
            Refund.new business_transaction:
                         create(:business_transaction, :old)
          end

          it { assert_permit(user, refund, :create) }
          it { assert_permit(user, refund, :new) }
        end

        describe 'and is refunded' do
          it { refute_permit(user, refund, :create) }
          it { refute_permit(user, refund, :new) }
        end
      end
    end

    describe 'who does not own business_transaction' do
      let(:user) { build :user }
      it { refute_permit(user, refund, :create) }
      it { refute_permit(user, refund, :new) }
    end
  end
end
