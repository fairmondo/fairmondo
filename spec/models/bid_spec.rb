require 'spec_helper'

describe Bid do

  it "has a valid Factory" do
    FactoryGirl.create(:bid).should be_valid
  end

  it {should validate_presence_of :user_id}
  it {should validate_presence_of :auction_transaction_id}
  it {should validate_presence_of :price_cents}

=begin
  it "checks that bid only accepts bids greater than the previous bid" do
    @bid = FactoryGirl.create(:bid)
    @bid.price_cents = Random.new.rand(1..500000)
    @bid.auction_transaction.max_bid = @bid.price_cents + Random.new.rand(1..500000)
    @bid.check_better.should eq false
  end
=end

end