#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe RefundsController do
  let(:seller) { FactoryGirl.create :user }
  let(:line_item_group) { FactoryGirl.create :line_item_group, seller: seller }
  let(:business_transaction) { FactoryGirl.create :business_transaction, :old, line_item_group: line_item_group }

  describe '#create' do
    describe 'for signed in users' do
      it 'should create refund request' do
        @refund_attrs = FactoryGirl.attributes_for :refund
        sign_in seller
        assert_difference 'Refund.count', 1 do
          post :create, refund: @refund_attrs, business_transaction_id: business_transaction.id
        end
      end
    end
  end

  describe '#new' do
    describe 'for signed in users' do
      it 'should render "new" view ' do
        sign_in seller
        get :new, user_id: seller.id, business_transaction_id: business_transaction.id
        assert_response :success
      end
    end
  end
end
