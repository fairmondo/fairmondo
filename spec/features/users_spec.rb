#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'spec_helper'

include Warden::Test::Helpers

describe 'User management' do

  context "for signed-out users" do
    it "should show a login button" do
      visit root_path
      page.should have_content("Login")
    end

    it "registers a new user" do
      Recaptcha.with_configuration(:public_key => '12345') do
        visit new_user_registration_path
      end
      expect do
        fill_in 'user_nickname',              with: 'nickname'
        fill_in 'user_email',                 with: 'email@example.com'
        fill_in 'user_password',              with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        choose 'user_type_legalentity'
        check 'user_legal'
        check 'user_privacy'
        check 'user_agecheck'
        click_button 'sign_up'
        User.find_by_email('email@example.com').confirm!
      end.to change(User, :count).by 1
    end

    it "should sign in a valid user" do
      user = FactoryGirl.create :user
      visit new_user_session_path

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_button 'Login'

      page.should have_content I18n.t 'devise.sessions.signed_in'
    end

    it "should not sign in a banned user" do
      user = FactoryGirl.create :user, banned: true
      visit new_user_session_path

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      expect { click_button 'Login' }.to raise_error # raises Tinycms error because "banned" is a page

      page.should_not have_content I18n.t 'devise.sessions.signed_in'
    end
  end

  context "for signed-in users" do
    before :each do
      @user = FactoryGirl.create(:user)
      login_as @user
    end

    describe "user profile page" do
      it "should open" do
        visit profile_user_path @user
        page.status_code.should == 200
      end
    end


    describe "user show page" do
      it 'should show the dashboard' do
        visit user_path(@user)
        page.should have_content I18n.t("common.text.profile")
      end

      it 'should not show the link to community' do
        visit user_path(@user)
        page.should_not have_content("TrustCommunity")
      end
    end

    describe "update of user registration" do
      before do
        visit edit_user_registration_path @user
        select 'Herr', from: 'user_title' # remove this line when possible
        select 'Deutschland', from: 'user_country' # remove this line when possible
      end

      context "updating non-sensitive data" do
        it "should update a users information without a password" do
          fill_in 'user_forename', with: 'chunky'
          fill_in 'user_surname', with: 'bacon'
          click_button I18n.t 'formtastic.actions.update'

          page.should have_content I18n.t 'devise.registrations.updated'
          @user.reload.fullname.should == 'chunky bacon'
        end
      end

      context "updating sensitive data" do
        before { fill_in 'user_email', with: 'chunky@bacon.com' }

        it "should not update a users email without a password" do
          click_button I18n.t 'formtastic.actions.update'

          page.should_not have_content I18n.t 'devise.registrations.updated'
          @user.reload.unconfirmed_email.should_not == 'chunky@bacon.com'
        end

        it "should update a users email with a password" do
          fill_in 'user_current_password', with: 'password'
          click_button I18n.t 'formtastic.actions.update'

          page.should have_content I18n.t 'devise.registrations.changed_email'
          @user.reload.unconfirmed_email.should == 'chunky@bacon.com'
        end
      end
    end
  end

end
