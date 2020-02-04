#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class CartTest < ActiveSupport::TestCase
  subject { Cart.new }

  describe 'attributes' do
    it { _(subject).must_respond_to :sold }
    it { _(subject).must_respond_to :line_item_count }
    it { _(subject).must_respond_to :purchase_emails_sent }
    it { _(subject).must_respond_to :purchase_emails_sent_at }
    it { _(subject).must_respond_to :created_at }
    it { _(subject).must_respond_to :updated_at }
    it { _(subject).must_respond_to :user_id }
    it { _(subject).must_respond_to :id }
  end

  it 'must be valid' do
    _(subject).must_be :valid?
  end

  describe 'associations' do
    should belong_to :user
    should have_many :line_item_groups
    should have_many :line_items
    should have_many :articles
  end

  describe 'methods' do
    describe '#empty?' do
      it 'should not be empty' do
        @cart = create :cart, :with_line_item_groups
        _(@cart.empty?).must_equal false
      end
    end
  end
end
