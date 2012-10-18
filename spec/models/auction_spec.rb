require 'spec_helper'

describe Auction do 
  
  it "has a valid Factory" do
    FactoryGirl.create(:auction).should be_valid
  end
  
  let(:auction) { FactoryGirl::create(:auction)}
  
  # it {should have_many :userevents}
  it {should have_many :images}
  
  it {should have_one :max_bid}
  
  it {should belong_to :seller}
  it {should belong_to :category}
  it {should belong_to :alt_category_1}
  it {should belong_to :alt_category_2}
  
  it {should validate_presence_of :title}
  it {should validate_presence_of :content}
  it {should validate_presence_of :category}
  it {should validate_presence_of :condition}
end