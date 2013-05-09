require 'spec_helper'

describe Image do
  it "has a valid Factory" do
    FactoryGirl.create(:image).should be_valid
  end

  it {should belong_to :auction}
end