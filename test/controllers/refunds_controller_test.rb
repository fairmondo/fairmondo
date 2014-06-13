require 'test_helper'
include FastBillStubber

describe RefundsController do
  let( :seller ){ FactoryGirl.create :user }
  let( :business_transaction ){ FactoryGirl.create :business_transaction_with_buyer, :old, seller: seller }

  before do
    stub_fastbill
  end

  describe 'POST ::create' do
    before do
      @refund_attrs = FactoryGirl.attributes_for :refund
      sign_in seller
    end

    describe 'for signed in users' do
      it 'should create refund request' do
        lambda do
          post :create, refund: @refund_attrs, business_transaction_id: business_transaction.id
        end.should change(Refund, :count).by 1
      end
    end
  end

  describe 'GET ::new' do
    describe 'for signed in users' do
      it 'should render "new" view ' do
        sign_in seller
        get :new, user_id: seller.id, business_transaction_id: business_transaction.id
        response.should be_success
      end
    end
  end
end
