require_relative '../test_helper'

describe Payment do
  subject { payment }
  let(:bt) { FactoryGirl.create(:business_transaction, :paypal_purchasable) }
  let(:payment) { bt.payment }

  describe "attributes" do
    it { subject.must_respond_to 'pay_key' }
    it { subject.must_respond_to 'error' }
    it { subject.must_respond_to 'last_ipn' }
    it { subject.must_respond_to 'created_at' }
    it { subject.must_respond_to 'updated_at' }
  end

  describe "associations" do
    it { subject.must have_many :business_transactions }
    it { subject.must have_many :line_item_groups }
  end

  # describe "validations" do
  #   it { should validate_uniqueness_of :pay_key }
  #   it { should validate_uniqueness_of :transaction_id }
  #   it { should validate_numericality_of :transaction_id }
  # end

  describe "methods" do
    describe "#init [state machine]" do
      it "should call #paypal_request" do
        payment.state.must_equal 'pending'
        payment.expects(:paypal_request)
        payment.init
        payment.state.must_equal 'initialized'
      end
    end

    describe "#paypal_request [private, before init]" do
      it "should save errors on API failure" do
        PaypalAdaptive::Response.any_instance.stubs(:success?).returns(false)
        payment.expects(:error=)
        payment.expects(:erroring)
        payment.send(:paypal_request)
      end

      it "should rescue a timeout" do
        Timeout.expects(:timeout).with(15).raises(Timeout::Error)
        payment.send(:paypal_request).must_equal false
      end
    end
  end
end
