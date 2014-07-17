require_relative '../test_helper'
include FastBillStubber
include PunditMatcher

describe RefundPolicy do
  before do
    stub_fastbill
  end

  let( :refund ){ FactoryGirl.create :refund }
  subject { RefundPolicy.new( user, refund ) }

  describe "for a visitor" do
    let( :user ) { nil }
    it 'should deny refund create for visitors' do
      subject.must_deny(:create)
      subject.must_deny(:new)
    end
  end

  describe 'for a logged in user' do
    describe 'who owns business_transaction' do
      let( :user ) { refund.business_transaction_seller }

      describe 'that is sold' do
        describe 'and is not refunded' do
          let( :refund ) { Refund.new business_transaction: FactoryGirl.create( :business_transaction, :old ) }
          it { subject.must_permit( :create ) }
          it { subject.must_permit( :new ) }
        end

        describe 'and is refunded' do
          it { subject.must_deny( :create ) }
          it { subject.must_deny(:new) }
        end
      end

    end

    describe 'who does not own business_transaction' do
      let( :user ) { FactoryGirl.create :user }
      it { subject.must_deny( :create ) }
      it { subject.must_deny( :new ) }
    end
  end
end
