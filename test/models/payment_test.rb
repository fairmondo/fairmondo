require_relative '../test_helper'

describe Payment do
  subject { payment }
  let(:payment) { Payment.new(transaction: FactoryGirl.create(:single_transaction)) }

  describe "attributes" do
    it { subject.must_respond_to 'transaction_id' }
    it { subject.must_respond_to 'pay_key' }
    it { subject.must_respond_to 'error' }
    it { subject.must_respond_to 'last_ipn' }
    it { subject.must_respond_to 'created_at' }
    it { subject.must_respond_to 'updated_at' }
  end

  describe "associations" do
    it { subject.must belong_to :transaction }
  end

  # describe "validations" do
  #   it { should validate_uniqueness_of :pay_key }
  #   it { should validate_uniqueness_of :transaction_id }
  #   it { should validate_numericality_of :transaction_id }
  # end

  describe "methods" do
    describe "#paypal_request [private, before_validation]" do
      it "should save paykey on API success" do
        payment.expects(:pay_key=).with('foobar')
        payment.expects(:state=).with(:initialized)
        payment.send(:paypal_request)
      end

      it "should save errors on API failure" do
        PaypalAdaptive::Response.any_instance.stub(:success?).and_return(false)
        payment.expects(:error=)
        payment.expects(:state=).with(:errored)
        payment.send(:paypal_request)
      end

      it "should rescue a timeout" do
        Timeout.expects(:timeout).with(15).raises(Timeout::Error)
        payment.send(:paypal_request).must_equal false
      end
    end
  end
end
