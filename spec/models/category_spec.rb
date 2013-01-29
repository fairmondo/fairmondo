require 'spec_helper'

describe Category do

  it "has a valid Factory" do
    FactoryGirl.create(:category).should be_valid
  end

  let(:category) { FactoryGirl::create(:category)}

  it {should have_many :auctions}
  
  it "should have the correct parent_id" do
    @category = FactoryGirl.create(:category)
    @anotherCategory = FactoryGirl.create(:category, :parent => @category)
    @anotherCategory.parent.should eq @category
  end

  it "should not have the correct parent_id" do
    @category = FactoryGirl.create(:category)
    @anotherCategory = FactoryGirl.create(:category)
    @anotherCategory.parent.should_not eq @category
  end
end