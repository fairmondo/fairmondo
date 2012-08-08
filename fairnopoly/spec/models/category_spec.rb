require 'spec_helper'

describe Category do 
  
  it "has a valid Factory" do
    FactoryGirl.create(:category).should be_valid
  end
  
  let(:category) { FactoryGirl::create(:category)}
  
  it {should have_many :auctions}
end