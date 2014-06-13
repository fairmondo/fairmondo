require 'test_helper'
include FastBillStubber
include PunditMatcher

describe RefundPolicy do
  before do
    stub_fastbill
  end

  let( :refund ){ FactoryGirl.create :refund }
  subject { RefundPolicy.new( user, refund ) }

  context "for a visitor" do
    let( :user ) { nil }
    it 'should deny refund create for visitors' do
      should deny(:create)
    end

    # it { should deny( :create ) }
    # it { should deny( :new) }
  end

  context 'for a logged in user' do
    context 'who owns business_transaction' do
      let( :user ) { refund.business_transaction_seller }

      context 'that is sold' do
        context 'and is not refunded' do
          let( :refund ) { Refund.new business_transaction: FactoryGirl.create( :business_transaction_with_buyer, :old ) }
          it { should grant_permission( :create ) }
          it { should grant_permission( :new ) }
        end

        context 'and is refunded' do
          it { should deny( :create ) }
          it { should deny(:new) }
        end
      end

      context 'that is not sold' do
        let( :refund ) { FactoryGirl.create :refund, :not_sold_business_transaction }
        it { should deny( :create ) }
        it { should deny( :new ) }
      end
    end

    context 'who does not own business_transaction' do
      let( :user ) { FactoryGirl.create :user }
      it { should deny( :create ) }
      it { should deny( :new ) }
    end
  end
end
