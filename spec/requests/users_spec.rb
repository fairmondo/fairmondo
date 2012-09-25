require 'spec_helper'

include Warden::Test::Helpers

describe 'User management' do
  
  describe "for non-signed-in users" do
    
    it "should show a sign in button" do
      visit root_path
      page.should have_content("Register")
    end
  end
  
  describe "for signed-in users" do
    
    before :each do
      @user = FactoryGirl.create(:user)
      login_as @user
    end

    it 'should show the dashboard' do
      visit dashboard_path
      page.should have_content("Profile")
     end
  end
  
end