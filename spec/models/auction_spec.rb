require 'spec_helper'

describe Auction do

  let(:auction) { FactoryGirl::create(:auction)}

  it {should have_many :images}

  it {should belong_to :seller}
  it {should have_many :categories}

  it "returns the title image" do
    auction = FactoryGirl.create(:auction)
    image = FactoryGirl.create(:image, :auction => auction)
    auction.title_image
  end
end