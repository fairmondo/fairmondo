require 'spec_helper'

describe Discount do
  describe 'associations' do
    it { should have_many :transactions }
  end

  describe 'attributes' do
    it { should respond_to :id }
    it { should respond_to :title }
    it { should respond_to :description }
    it { should respond_to :start_time }
    it { should respond_to :end_time }
    it { should respond_to :percent }
    it { should respond_to :max_discounted_value_cents }
    it { should respond_to :num_of_discountable_articles }
    it { should respond_to :created_at }
    it { should respond_to :updated_at }
  end

  describe 'methods' do
    describe '::discount_chain' do
      context 'calculated discount is bigger than remaining discount' do
        let(:discount){ FactoryGirl.create :discount, :small }
        let(:transaction){ FactoryGirl.create :transaction_with_buyer, article: FactoryGirl.create( :article, discount: discount) }

        it 'should set discount value to remaining discount' do
          transaction.article.calculate_fees_and_donations
          Discount.discount_chain( transaction )
          transaction.discount_id.should eq discount.id
          transaction.discount_value_cents.should eq discount.max_discounted_value_cents
        end
      end
    end
  end
end
