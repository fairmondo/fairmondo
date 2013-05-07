require 'spec_helper'

describe PrivateUser do

  let(:user) { FactoryGirl::create(:private_user)}
  subject { user }

  it "should have a valid factory" do
    should be_valid
  end

  it "should return the same model_name as User" do
    PrivateUser.model_name.should eq User.model_name
  end

end