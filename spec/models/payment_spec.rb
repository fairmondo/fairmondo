require 'spec_helper'

describe Payment do
  subject { payment }
  let(:payment) { Payment.new(transaction: FactoryGirl.create(:single_transaction)) }

  describe "attributes" do
    it { should respond_to 'transaction_id' }
    it { should respond_to 'pay_key' }
    it { should respond_to 'error' }
    it { should respond_to 'last_ipn' }
    it { should respond_to 'created_at' }
    it { should respond_to 'updated_at' }
  end

  describe "associations" do
    it { should belong_to :transaction }
  end

  # describe "validations" do
  #   it { should validate_uniqueness_of :pay_key }
  #   it { should validate_uniqueness_of :transaction_id }
  #   it { should validate_numericality_of :transaction_id }
  # end

  describe "methods" do
    describe "#paypal_request [private, before_validation]" do
      it "should save paykey on API success" do
        payment.should_receive(:pay_key=).with('foobar')
        payment.should_receive(:state=).with(:initialized)
        payment.send(:paypal_request)
      end

      it "should save errors on API failure" do
        PaypalAdaptive::Response.any_instance.stub(:success?).and_return(false)
        payment.should_receive(:error=)
        payment.should_receive(:state=).with(:errored)
        payment.send(:paypal_request)
      end

      it "should rescue a timeout" do
        Timeout.should_receive(:timeout).with(15).and_raise(Timeout::Error)
        payment.send(:paypal_request).should eq false
      end
    end
  end
end
