require 'spec_helper'

describe Image do  
  it {should belong_to :auction}
  
    it "has a valid Factory" do
      FactoryGirl.create(:image).should be_valid
    end
end