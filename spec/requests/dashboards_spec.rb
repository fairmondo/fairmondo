require 'spec_helper'

include Warden::Test::Helpers

describe 'Dashboard' do

  describe "for non-signed-in users" do

    it "should show a sign in button" do
      visit dashboard_path
      page.should have_content("Login")
    end
  end

  describe "for signed-in users" do

    before :each do
      @user = FactoryGirl.create(:user)
      login_as @user
      visit dashboard_path
    end

    it 'should show the dashboard' do
      page.should have_content("FFP")
    end

    it 'Buy link shows the Buy page' do
      click_link 'Buy'
      page.should have_content("New")
    end

    it 'Sell link shows the Sell page' do
      click_link 'Sell'
      page.should have_content("Title")
    end

    it 'Community link shows the Community page' do
      click_link 'Community'
      page.should have_selector('h2', :content =>  'Invitor')
    end

    it 'Profile link shows the profile page' do
      click_link 'Profile'
      page.should have_content("FFP")
    end

    it 'Admin link only shown for admin user' do
      page.should_not have_content('Admin')
    end
  end

  describe "for admin users" do

    before :each do
      @user = FactoryGirl.create(:user, :admin => true)
      @ffp = FactoryGirl.create(:ffp)
      login_as @user
      visit dashboard_path
    end

    it 'Admin link only shown for admin user' do
      page.should have_content('Admin')
    end

    it 'Admin link shows the Admin page' do
      click_link 'Admin'
      page.should have_selector('h2', :content => 'Admin')
    end
  end
end