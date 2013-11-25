require 'spec_helper'

describe 'Refund' do
  describe 'associations' do
    it { should belong_to :transaction }
  end

  describe 'attributes' do
    it { should respond_to :refund_reason }
    it { should respond_to :refund_explanation }
    it { should validate_presence_of :refund_reason }
    it { should validate_presence_of :refund_explanation }
  end

  describe 'methods' do
    desribe '#has_requested_refund' do
      context 'when refund_reason and refund_explnation are nil' do
        it 'should return true' do

        end
      end
      context 'when refund_reason and refund_explanation are not nil' do
        it 'should return false' do
        end
      end
    end
  end
end
