require 'spec_helper'

include Warden::Test::Helpers

describe 'Dashboard' do

  describe "for non-signed-in users" do

    it "should show a sign in button" do
      visit dashboard_path
      page.should have_content("Sign in")
    end
  end

  describe "for signed-in users" do

    before :each do
      @user = FactoryGirl.create(:user)
      login_as @user
      visit dashboard_path
    end

    it 'should show the dashboard' do
      page.should have_content(@user.email)
    end

    it 'Profile link shows dashboard_path' do
      click_link 'Profile'
      page.should have_content(@user.email)
    end

    it 'Edit Profile link shows Edit Profile page' do
      click_link 'Edit Profile'
      page.should have_selector('h2', :content =>  'Edit Profile')
    end

    it 'Timeline link shows the Timeline page' do
      click_link 'Timeline'
      page.should have_selector('ol', :content =>  'timeline')
    end

    it 'Friends link shows the Friends page' do
      click_link 'Friends'
      page.should have_selector('h2', :content =>  'Friends')
    end

    it 'Community link shows the Community page' do
      click_link 'Community'
      page.should have_selector('h2', :content =>  'Invitor')
    end

    it 'Trade link shows the Trade page' do
      click_link 'Trade'
      page.should have_selector('h2', :content =>  'My Offers')
    end

    it 'Settings link shows the Settings page' do
      click_link 'Settings'
      page.should have_selector('h2', :content =>  'Settings')
    end

    it 'Admin link only shown for admin user' do
      page.should_not have_content('Admin')
    end
  end

  describe "for admin users" do

    before :each do
      @user = FactoryGirl.create(:user, :admin => true)
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

    it 'Admin link shows the Admin page' do
      click_link 'Admin'
      page.should_not have_content('delete')
    end
  end
end