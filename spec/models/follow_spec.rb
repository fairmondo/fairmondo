require 'spec_helper'

describe Follow do  
  
  it "has a valid Factory" do
    FactoryGirl.create(:follow).should be_valid
  end
  
  let(:follow) { FactoryGirl::create(:follow)}

  it { should belong_to :followable}
  it { should belong_to :follower}

  it "changes block attribute" do
    follow = FactoryGirl.create(:follow)
    follow.block!
    follow.blocked.should == true
  end

end