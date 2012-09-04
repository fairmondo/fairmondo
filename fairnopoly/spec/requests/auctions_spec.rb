require 'spec_helper'

include Warden::Test::Helpers

describe 'Auction management' do

  describe "for non-signed-in users" do

    before :each do
      @user = FactoryGirl.create(:user)
      login_as @user
    end

    it 'creates an auction after login' do
      visit new_category_path
      fill_in 'Name', with: 'New category'
      fill_in 'Desc', with: 'Desc'
      fill_in 'Level', with: 0
      fill_in 'Parent', with: 0
      click_button "Create Category"

      click_link 'Logout'

      visit new_auction_path
      page.should have_content("New Auction")
      click_button 'New category'
      fill_in 'Title', with: 'Auction title'
      choose 'New'
      fill_in 'Content', with: 'Auction content'
      fill_in 'Price', with: 10
      click_button "Create Auction"
      page.should have_content("You need to sign in or sign up before continuing.")

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Sign In'
      page.should have_content("Auction was successfully created")
    end
  end

  describe "for signed-in users" do
    before :each do
      @user = FactoryGirl.create(:user)
      login_as @user
    end

    it 'creates an auction' do
      visit new_category_path
      fill_in 'Name', with: 'New category'
      fill_in 'Desc', with: 'Desc'
      fill_in 'Level', with: 0
      fill_in 'Parent', with: 0
      click_button "Create Category"

      visit new_auction_path
      page.should have_content("New Auction")
      lambda do
        click_button 'New category'
        fill_in 'Title', with: 'Auction title'
        choose 'New'
        fill_in 'Content', with: 'Auction content'
        fill_in 'Price', with: 10
        click_button "Create Auction"
      end.should change(Auction, :count).by(1)
    end
  end
end