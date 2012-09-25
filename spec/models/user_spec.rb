require 'spec_helper'

describe User do
  
  it "has a valid Factory" do
    FactoryGirl.create(:user).should be_valid
  end
  
  let(:user) { FactoryGirl::create(:user)}
  
  it {should validate_presence_of :email}
  
  it {should have_many :auctions}
  it {should have_many :userevents}
  it {should have_many :bids}
  it {should have_many :invitations}
end