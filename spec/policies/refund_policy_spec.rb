require 'spec_helper'
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
    context 'who owns transaction' do
      let( :user ) { refund.transaction_seller }

      context 'that is sold' do
        context 'and is not refunded' do
          let( :refund ) { Refund.new transaction: FactoryGirl.create( :transaction_with_buyer, :old ) }
          it { should permit( :create ) }
          it { should permit( :new ) }
        end

        context 'and is refunded' do
          it { should deny( :create ) }
          it { should deny(:new) }
        end
      end

      context 'that is not sold' do
        let( :refund ) { FactoryGirl.create :refund, :not_sold_transaction }
        it { should deny( :create ) }
        it { should deny( :new ) }
      end
    end

    context 'who does not own transaction' do
      let( :user ) { FactoryGirl.create :user }
      it { should deny( :create ) }
      it { should deny( :new ) }
    end
  end
end
