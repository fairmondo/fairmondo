#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

describe Cart do
  subject { Cart.new }

  describe 'attributes' do
    it { subject.must_respond_to :sold }
    it { subject.must_respond_to :line_item_count }
    it { subject.must_respond_to :purchase_emails_sent }
    it { subject.must_respond_to :purchase_emails_sent_at }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :user_id }
    it { subject.must_respond_to :id }
  end

  it 'must be valid' do
    subject.must_be :valid?
  end

  describe 'associations' do
    it { subject.must belong_to :user }
    it { subject.must have_many :line_item_groups }
    it { subject.must have_many :line_items }
    it { subject.must have_many :articles }
  end

  describe 'methods' do
    describe '#empty?' do
      it 'should not be empty' do
        @cart = FactoryGirl.create :cart, :with_line_item_groups
        @cart.empty?.must_equal false
      end
    end
  end
end
