require 'spec_helper'

describe Auction do

  let(:auction) { FactoryGirl::create(:auction)}

  it {should have_many :images}

  it {should belong_to :seller}
  it {should have_many :categories}

  it "validates expire" do
    auction = FactoryGirl.create(:auction)
    auction.validate_expire.should eq true
  end

  it "validates expire with a short time" do
    auction = FactoryGirl.create(:auction)
    auction.expire = 0.5.hours.from_now
    auction.validate_expire.should eq false
  end

  it "validates expire with a long time" do
    auction = FactoryGirl.create(:auction)
    auction.expire = 2.years.from_now
    auction.validate_expire.should eq false
  end

  it "returns the title image" do
    auction = FactoryGirl.create(:auction)
    image = FactoryGirl.create(:image, :auction => auction)
    auction.title_image
  end
end