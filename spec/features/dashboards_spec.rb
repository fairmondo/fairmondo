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
      page.should have_content("Profil bearbeiten")
    end

    it 'Buy link shows the Buy page' do
      click_link 'Buy'
      page.should have_content("New")
    end

    it 'Sell link shows the Sell page' do
      click_link 'Sell'
      page.should have_content("Title")
    end

 #   it 'Community link is invisible for not invited users' do
 #     page.should_not have_content('Community')
 #   end

    it 'Profile link shows the profile page' do
      click_link 'Profile'
      page.should have_content("Sammlungen")
    end

    it 'Admin link only shown for admin user' do
      page.should_not have_content('Admin')
    end

    describe "connection to private messaging" do
      describe "when dashboard belongs to different user" do
        before(:each) do
          visit dashboard_path(id: FactoryGirl.create(:user).id)
        end
        it 'should show a link to the private messaging system' do
          page.should have_content("Nachricht schreiben")
        end

        it 'should link to the private messaging system' do
          click_link 'Nachricht schreiben'
          page.should have_content("Neue Nachricht")
        end
      end

      describe "when dashboard belongs to logged in user" do
        it "should should show a link to the user's inbox" do
          page.should have_content 'Postfach'
        end

        it 'should link to the private messaging system' do
          click_link 'Postfach'
          page.should have_content("Meine Nachrichten")
        end
      end
    end
  end

#  describe "for signed-in TC users" do
#
#    before :each do
#      @user = FactoryGirl.create(:user, :trustcommunity => true)
#      login_as @user
#      visit dashboard_path
#    end
#
#    it 'Community link is visible for invited users' do
#      page.should_not have_content('Community')
#    end
#
#  end

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
      page.should have_selector('#active_admin_content')
    end
  end
end