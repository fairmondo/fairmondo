#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe Payment do
  subject { payment }
  let(:payment) { create(:paypal_payment) }

  describe 'attributes' do
    it { subject.must_respond_to 'pay_key' }
    it { subject.must_respond_to 'line_item_group' }
    it { subject.must_respond_to 'error' }
    it { subject.must_respond_to 'last_ipn' }
    it { subject.must_respond_to 'created_at' }
    it { subject.must_respond_to 'updated_at' }
  end

  describe 'associations' do
    # it { subject.must have_many :business_transactions }
    it { subject.must belong_to :line_item_group }
  end

  # describe "validations" do
  #   it { should validate_uniqueness_of :pay_key }
  #   it { should validate_uniqueness_of :transaction_id }
  #   it { should validate_numericality_of :transaction_id }
  # end

  describe 'methods' do
    describe '#init [state machine]' do
      it 'should initialize successfully' do
        payment.state.must_equal 'pending'
        payment.init
        payment.state.must_equal 'initialized'
      end
    end

    describe '#initialize_payment [private, called within init]' do
      it 'should return true for a base Payment' do
        Payment.new.send(:initialize_payment).must_equal true
      end

      it 'should save errors on API failure' do
        PaypalAdaptive::Response.any_instance.stubs(:success?).returns(false)
        payment.expects(:error=)
        payment.send(:initialize_payment)
      end

      it 'should rescue a timeout and error instead' do
        Timeout.expects(:timeout).with(15).raises(Timeout::Error)
        payment.init
        payment.state.must_equal 'errored'
      end
    end
  end
end
