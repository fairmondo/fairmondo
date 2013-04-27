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

    it 'gets redirected to Admin Dashboard' do
      page.should have_content('Dashboard')
    end

  end
end