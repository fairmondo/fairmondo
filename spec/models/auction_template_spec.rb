require 'spec_helper'

describe AuctionTemplate do
  let(:auction_template) { FactoryGirl.create(:auction_template) }
  subject { auction_template }

  it "should have a valid factory" do
    should be_valid
  end

  it {should validate_presence_of :name}
  it {should validate_uniqueness_of(:name).scoped_to(:user_id)}
  it {should validate_presence_of :user_id}

  it {should belong_to :user}
  it {should have_one(:auction).dependent(:destroy)}
  it {should accept_nested_attributes_for :auction}

  describe "auctions_auction_template validation" do
    before do
      auction_template = FactoryGirl.build(:auction_template)
    end

    it "should return an auction template" do
      auction_template.send("auctions_auction_template").should eq auction_template
    end

    it "should throw an error when no auction is present" do
      auction_template.auction = nil
      auction_template.should_not be_valid
    end
  end


  describe "deep_auction_attributes method" do
    it "should return a hash with attributes of the underlying auction" do
      result = auction_template.deep_auction_attributes
      result.class.should eq Hash
      result['id'].should eq auction_template.auction.id
    end
  end

  describe "non_assignable_values method" do
    its(:non_assignable_values) { should eq ["id", "created_at", "updated_at", "auction_id"] }
  end
end
