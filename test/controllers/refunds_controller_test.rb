require 'test_helper'
include FastBillStubber

describe RefundsController do
  let( :seller ){ FactoryGirl.create :user }
  let( :business_transaction ){ FactoryGirl.create :business_transaction_with_buyer, :old, seller: seller }


  describe '#create' do

    describe 'for signed in users' do
      it 'should create refund request' do
        @refund_attrs = FactoryGirl.attributes_for :refund
        sign_in seller
        stub_fastbill
        assert_difference 'Refund.count', 1 do
          post :create, refund: @refund_attrs, business_transaction_id: business_transaction.id
        end
      end
    end
  end

  describe '#new' do
    describe 'for signed in users' do
      it 'should render "new" view ' do
        stub_fastbill
        sign_in seller
        get :new, user_id: seller.id, business_transaction_id: business_transaction.id
        assert_response :success
      end
    end
  end
end
