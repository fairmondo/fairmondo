#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'spec_helper'

include Warden::Test::Helpers

describe 'Dashboard' do

  context "for signed-out users" do

    before :each do
      @user = FactoryGirl.create :user
    end

    it "should show a sign in button" do
      visit user_path(@user)
      page.should have_content I18n.t('common.actions.login')
    end
  end

  context "for signed-in users" do

    before :each do
      @user = FactoryGirl.create :user
      login_as @user
      visit user_path(@user)
    end

    it 'should show the dashboard' do
      page.should have_content("Profil bearbeiten")
    end

    it 'Sell link shows the Sell page', slow: true do
      click_link I18n.t('header.sell')
      page.should have_content I18n.t('formtastic.labels.article.title')
    end

 #   it 'Community link is invisible for not invited users' do
 #     page.should_not have_content('Community')
 #   end

    it 'Show Profile link shows the user profile' do
      visit profile_user_path(@user)
      page.should have_content @user.nickname
    end

    it 'Profile link shows the profile page' do
      click_link I18n.t('header.profile')
      page.should have_content("Sammlungen")
    end

    it 'Admin link only shown for admin user' do
      page.should_not have_content('Admin')
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
      visit user_path(@user)
    end

    it 'Admin link only shown for admin user' do
      page.should have_content('Admin')
    end

    it 'Admin link shows the Admin page' do
      click_link 'Admin'
      page.should have_content I18n.t('admin.actions.dashboard.title')
    end
  end
end
