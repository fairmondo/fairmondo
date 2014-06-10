require 'spec_helper'
include FastBillStubber

describe RefundsController do
  let( :user ){ FactoryGirl.create :user }
  let( :business_transaction ){ FactoryGirl.create :business_transaction_with_buyer, :old, :seller => user }

  before do
    stub_fastbill
  end

  describe 'POST ::create' do
    before do
      @refund_attrs = FactoryGirl.attributes_for :refund
      sign_in user
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
        sign_in user
        get :new, user_id: seller.id
        response.should be_success
      end
    end
  end
end
