require 'spec_helper'

describe User do

  let(:user) { FactoryGirl::create(:user)}

  it "has a valid Factory" do
    user.should be_valid
  end

  it {should validate_presence_of :email}

  it {should have_many :auctions}
  it {should have_many :bids}
  it {should have_many :invitations}

  it "returns correct fullname" do
    user.fullname.should eq "#{user.forename} #{user.surname}"
  end

  it "returns correct display_name" do
    user.display_name.should eq user.fullname
  end

  it "returns correct name" do
    user.name.should eq user.nickname
  end

  describe "method: legal_entity_terms_ok" do
    it "returns true when valid" do
      user.legal_entity_terms_ok.should be_true
    end

    it "returns false when invalid" do
      user.nickname = nil # make user invalid
      user.legal_entity_terms_ok.should be_false
    end
  end

  # describe "Private User" do
  #   it "should return the same model name as a normal User" do
  #     private_user = FactoryGirl.create(:user)
  #     user.model_name
  #   end
  # end

end