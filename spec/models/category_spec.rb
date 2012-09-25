require 'spec_helper'

describe Category do 
  
  it "has a valid Factory" do
    FactoryGirl.create(:category).should be_valid
  end
  
  let(:category) { FactoryGirl::create(:category)}
  
  it "should have the correct parent_id" do
    @category = FactoryGirl.create(:category)
    @anotherCategory = FactoryGirl.create(:category, :parent_id => @category)
    @anotherCategory.parent.should eq @category
  end
  it {should have_many :auctions}
end