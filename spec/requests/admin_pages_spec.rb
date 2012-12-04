require 'spec_helper'

include Warden::Test::Helpers

describe 'ActiveAdminPages' do

  describe 'for non-admin users' do

    before :each do
      @user = FactoryGirl.create(:user)
      login_as @user
    end

  end

  describe 'for admin users' do
    before :each do
      @admin = FactoryGirl.create(:admin_user)
      login_as @admin
      visit root_path
    end

    it 'shows the Admin link' do
      page.should have_content('Admin')
    end

    before :each do
      click_on 'Admin'
    end

    it 'gets redirected to ActiveAdmin Dashboard' do
      page.should have_content('Dashboard')
    end

    it 'should delete an Auction' do
      @auction = FactoryGirl.create(:auction)
      click_on 'Auctions'
      expect {
        click_on 'Delete'
      }.to change(Auction, :count).by(-1)
    end

    it 'should delete a category' do
      @category = FactoryGirl.create(:category)
      click_on 'Categories'
      expect {
        click_on 'Delete'
      }.to change(Category, :count).by(-1)
    end

    it 'should create a category' do
      click_on 'Categories'
      click_on 'New Category'
      expect {
        fill_in 'Name', with: 'Name'
        click_on 'Create Category'
      }.to change(Category, :count).by(1)
    end

  #  it 'should show the ffp page' do
  #    click_on 'Fair Founding Points'
  #    expect {
  #      click_on 'Delete'
  #    }.to change(Category, :count).by(-1)
  #  end

  end
end