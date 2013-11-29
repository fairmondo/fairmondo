require 'spec_helper'

describe Discount do
  describe 'associations' do
    it { should have_many :discount_cards }
  end

  describe 'attributes' do
    it { should respond_to :title }
    it { should respond_to :description }
    it { should respond_to :start_time }
    it { should respond_to :end_time }
    it { should respond_to :percent }
    it { should respond_to :max_discounted_value_cents }
    it { should respond_to :num_of_discountable_articles }
  end
end
