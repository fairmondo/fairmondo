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

  describe "legal_entity_terms_ok" do
    it "should return true when everything is valid" do
      user.legal_entity_terms_ok.should be_true
    end

    it "should return false when one attribute is not valid" do
      user.terms = []
      user.legal_entity_terms_ok.should be_false
    end
  end
end