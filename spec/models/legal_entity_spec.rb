require 'spec_helper'

describe LegalEntity do

  let(:user) { FactoryGirl::create(:legal_entity)}
  subject { user }

  it "should have a valid factory" do
    should be_valid
  end

  it "should return the same model_name as User" do
    LegalEntity.model_name.should eq User.model_name
  end

  
end