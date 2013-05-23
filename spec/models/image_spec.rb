require 'spec_helper'

describe Image do
  it "has a valid Factory" do
    FactoryGirl.create(:image).should be_valid
  end

  it {should have_and_belong_to_many :articles}
end