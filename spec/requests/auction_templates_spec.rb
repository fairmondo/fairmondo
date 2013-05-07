require 'spec_helper'

include Warden::Test::Helpers

describe "AuctionTemplates" do
  describe "GET /auction_templates/new" do
    include CategorySeedData

    before :each do
      setup_categories
      @user = FactoryGirl.create(:user)
      login_as @user
    end

    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get new_auction_template_path
      response.status.should be(200)
    end
  end
end
