require 'spec_helper'

describe Category do

  let(:category) { FactoryGirl::create(:category)}

  it "has a valid Factory" do
    category.should be_valid
  end

  it {should have_and_belong_to_many :articles}

  it "should have the correct parent_id" do
    @anotherCategory = FactoryGirl.create(:category, :parent => category)
    @anotherCategory.parent.should eq category
  end

  it "should not have the correct parent_id" do
    @anotherCategory = FactoryGirl.create(:category)
    @anotherCategory.parent.should_not eq category
  end

  it "should return self_and_ancestors_ids" do
    childCategory = FactoryGirl.create(:category, parent: category)
    childCategory.self_and_ancestors_ids.should eq [childCategory.id, category.id]
  end
end