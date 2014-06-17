require 'test_helper'

describe Refund do
  subject { Refund.new }

  describe 'associations' do
    it { subject.must belong_to :business_transaction }
  end

  describe 'attributes' do
    it { subject.must_respond_to :reason }
    it { subject.must_respond_to :description }
    it { subject.must_respond_to :business_transaction_id }
  end

  describe 'validations' do
    it { subject.must validate_presence_of :reason }
    it { subject.must validate_presence_of :description }
    it { subject.must validate_presence_of :business_transaction_id }
  end
end
