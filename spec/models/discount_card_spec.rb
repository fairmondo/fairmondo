require 'spec_helper'

describe DiscountCard do
  describe 'associations' do
    it { should belong_to :discount }
    it { should belong_to :user }
  end

  describe 'attributes' do
    it { should respond_to :discount_id }
    it { should respond_to :user_id }
    it { should respond_to :value_cents }
    it { should respond_to :num_of_articles }
  end
end
