#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  subject { Rating.new }

  describe 'model attributes' do
    it { _(subject).must_respond_to :id }
    it { _(subject).must_respond_to :created_at }
    it { _(subject).must_respond_to :updated_at }
    it { _(subject).must_respond_to :rating }
    it { _(subject).must_respond_to :rated_user_id }
    it { _(subject).must_respond_to :text }
    it { _(subject).must_respond_to :line_item_group_id }
  end

  describe 'associations' do
    should belong_to :line_item_group
    should belong_to :rated_user
  end

  describe 'enumerization' do # see business_transaction_test
    should enumerize(:rating).in(:positive, :neutral, :negative)
  end
end
