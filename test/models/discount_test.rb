require 'test_helper'

describe Discount do
  subject { Discount.new }

  describe 'associations' do
    it { subject.must have_many :business_transactions }
  end

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :title }
    it { subject.must_respond_to :description }
    it { subject.must_respond_to :start_time }
    it { subject.must_respond_to :end_time }
    it { subject.must_respond_to :percent }
    it { subject.must_respond_to :max_discounted_value_cents }
    it { subject.must_respond_to :num_of_discountable_articles }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
  end

  describe 'methods' do
    describe '::discount_chain' do
      describe 'calculated discount is bigger than remaining discount' do
        let(:discount){ FactoryGirl.create :discount, :small }
        let(:business_transaction){ FactoryGirl.create :business_transaction_with_buyer, article: FactoryGirl.create( :article, discount: discount) }

        it 'should set discount value to remaining discount' do
          business_transaction.article.calculate_fees_and_donations
          Discount.discount_chain( business_transaction )
          business_transaction.discount_id.must_equal discount.id
          business_transaction.discount_value_cents.must_equal discount.max_discounted_value_cents
        end
      end
    end
  end
end
