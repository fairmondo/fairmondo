require 'test_helper'

describe Refund do
  describe 'associations' do
    it { should belong_to :business_transaction }
  end

  describe 'attributes' do
    it { should respond_to :reason }
    it { should respond_to :description }
    it { should respond_to :business_transaction_id }
    it { should validate_presence_of :reason }
    it { should validate_presence_of :description }
    it { should validate_presence_of :business_transaction_id }
  end
end
