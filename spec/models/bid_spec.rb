require 'spec_helper'

describe Bid do
  
  it "has a valid Factory" do
    FactoryGirl.create(:bid).should be_valid
  end

end