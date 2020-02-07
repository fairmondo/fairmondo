#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class RefundsControllerTest < ActionController::TestCase
  let(:seller) { create :user }
  let(:line_item_group) { create :line_item_group, seller: seller }
  let(:business_transaction) { create :business_transaction, :old, line_item_group: line_item_group }

  describe '#create' do
    describe 'for signed in users' do
      it 'should create refund request' do
        @refund_attrs = attributes_for :refund
        sign_in seller
        assert_difference 'Refund.count', 1 do
          post :create, params:{ refund: @refund_attrs, business_transaction_id: business_transaction.id }
        end
      end
    end
  end

  describe '#new' do
    describe 'for signed in users' do
      it 'should render "new" view ' do
        sign_in seller
        get :new, params:{ user_id: seller.id, business_transaction_id: business_transaction.id }
        assert_response :success
      end
    end
  end
end
