require_relative '../test_helper'

class RatingTest < ActiveSupport::TestCase
  subject { Rating.new }

  describe "model attributes" do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :rating }
    it { subject.must_respond_to :rated_user_id }
    it { subject.must_respond_to :text }
    it { subject.must_respond_to :line_item_group_id }
  end

  describe "associations" do
    it { subject.must belong_to :line_item_group }
    it { subject.must belong_to :rated_user  }
  end

  describe "enumerization" do # see business_transaction_test
    should enumerize(:rating).in(:positive, :neutral, :negative)
  end
end
