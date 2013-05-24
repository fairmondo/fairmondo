require 'spec_helper'

describe Invitation do

  it "has a valid Factory" do
    FactoryGirl.create(:invitation).should be_valid
  end

  it {should belong_to :sender}

  it {should validate_presence_of :name}
  it {should validate_presence_of :email}
  it {should validate_presence_of :relation}
  it {should validate_presence_of :trusted_1}
  it {should validate_presence_of :trusted_2}

  it "!validates the sender" do
    @invitation = FactoryGirl.create(:invitation)
    @invitation.validate_sender.should eq false
  end

  it "validates the sender" do
    @invitation = FactoryGirl.create(:invitation)
    @invitation.sender.trustcommunity = true
    @invitation.validate_sender.should eq true
  end
end
