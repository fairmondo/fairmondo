#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class DiscountTest < ActiveSupport::TestCase
  subject { Discount.new }

  describe 'associations' do
    should have_many :business_transactions
  end

  describe 'attributes' do
    it { _(subject).must_respond_to :id }
    it { _(subject).must_respond_to :title }
    it { _(subject).must_respond_to :description }
    it { _(subject).must_respond_to :start_time }
    it { _(subject).must_respond_to :end_time }
    it { _(subject).must_respond_to :percent }
    it { _(subject).must_respond_to :max_discounted_value_cents }
    it { _(subject).must_respond_to :num_of_discountable_articles }
    it { _(subject).must_respond_to :created_at }
    it { _(subject).must_respond_to :updated_at }
  end

  describe 'methods' do
    describe '::discount_chain' do
      it 'should set discount value to remaining discount if calculated discount is bigger than remaining discount' do
        discount = create(:small_discount)
        business_transaction = create :business_transaction, article: create(:article, discount: discount)
        business_transaction.article.calculate_fees_and_donations
        Discount.discount_chain(business_transaction)
        business_transaction.discount_id.must_equal discount.id
        business_transaction.discount_value_cents.must_equal discount.max_discounted_value_cents
      end

      it 'should set discount value to the calculated discount if calculated discount is smaller than remaining discount' do
        discount = create(:big_discount)
        business_transaction = create :business_transaction, article: create(:article, discount: discount, price: 1)
        business_transaction.article.calculate_fees_and_donations
        Discount.discount_chain(business_transaction)
        business_transaction.discount_id.must_equal discount.id
        business_transaction.discount_value_cents.must_equal 10 # minimum discount
      end
    end
  end
end
