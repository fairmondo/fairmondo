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
include FastBillStubber

include Warden::Test::Helpers

describe 'User management' do
  let(:user) { FactoryGirl.create :user, :fastbill }

  before do
    stub_fastbill #for user update calls
  end

  context "for signed-out users" do
    it "should show a login button" do
      visit root_path
      page.should have_content I18n.t('common.actions.login')
    end

    it "registers a new user" do
      visit new_user_registration_path

      within '.registrations-form' do
        fill_in 'user_nickname',              with: 'nickname'
        fill_in 'user_email',                 with: 'email@example.com'
        fill_in 'user_password',              with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        choose 'user_type_legalentity'
        check 'user_legal'
        check 'user_agecheck'
      end
      expect {click_button 'sign_up'}.to change(User, :count).by 1
    end

    it "should sign in a valid user" do
      visit new_user_session_path

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_button 'Login'

      page.should have_content I18n.t 'devise.sessions.signed_in'
    end

    it "should not sign in a banned user" do
      user = FactoryGirl.create :user, banned: true
      FactoryGirl.create :content, key:'banned', body: '<p>You are banned.</p>'
      visit new_user_session_path

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_button 'Login'

      page.should have_content 'You are banned.'
      page.should_not have_content I18n.t 'devise.sessions.signed_in'
    end

    describe "user dashboard" do
      it "should be accessible" do
        article = FactoryGirl.create :article
        visit article_path article
        find('.User-image a').click
        current_path.should eq user_path article.seller
      end
    end

    describe "user profile (legal_entity)" do
      it "should be accessible" do
        user = FactoryGirl.create :legal_entity
        visit user_path user
        click_link I18n.t 'common.text.about_terms'
        current_path.should eq profile_user_path user
      end
    end
  end

  context "for signed-in users" do
    describe "user profile page" do
      it "should open" do
        login_as user
        visit profile_user_path user
        page.status_code.should == 200
      end
    end


    describe "user show page" do
      before :each do
        login_as user
      end

      it 'should show the dashboard' do
        visit user_path user
        page.should have_content I18n.t("header.profile")
      end

      it 'should not show the link to community' do
        visit user_path user
        page.should_not have_content("TrustCommunity")
      end
    end

    describe "user edit" do
      context "for every type of user" do
        before { login_as user }

        it "should show the correct data and fields" do
          visit edit_user_registration_path user
          # Heading
          page.should have_css "h1", text: I18n.t('common.actions.edit_profile')

          # Account Data
          page.should have_content I18n.t 'formtastic.labels.user.legal_entity'
          page.should have_content I18n.t 'formtastic.labels.user.nickname'
          page.should have_content user.nickname
          page.should have_content I18n.t 'formtastic.labels.user.customer_number'
          page.should have_content user.customer_nr
          page.should have_content I18n.t 'formtastic.labels.user.image'

          # Account Fields
          page.should have_css 'h3', text: I18n.t('users.title.login')
          page.should have_content I18n.t 'formtastic.labels.user.email'
          page.should have_content I18n.t 'users.change_password'
          page.should have_content I18n.t 'formtastic.labels.user.password'
          page.should have_content I18n.t 'formtastic.labels.user.current_password'

          # State Fields
          page.should have_css 'h3', text: I18n.t('users.title.state')
          page.should have_content I18n.t 'formtastic.labels.user.vacationing'

          # Contact Info Fields
          page.should have_content I18n.t 'formtastic.labels.user.title'
          page.should have_content I18n.t 'formtastic.labels.user.forename'
          page.should have_content I18n.t 'formtastic.labels.user.surname'
          page.should have_content I18n.t 'formtastic.labels.user.country'
          page.should have_content I18n.t 'formtastic.labels.user.street'
          page.should have_content I18n.t 'formtastic.labels.user.address_suffix'
          page.should have_content I18n.t 'formtastic.labels.user.city'
          page.should have_content I18n.t 'formtastic.labels.user.zip'
          page.should have_content I18n.t 'formtastic.labels.user.phone'
          page.should have_content I18n.t 'formtastic.labels.user.mobile'
          page.should have_content I18n.t 'formtastic.labels.user.fax'

          # Profile Fields
          page.should have_content I18n.t 'formtastic.labels.user.about_me'

          page.should have_button I18n.t 'formtastic.actions.update'
        end

        context "updating non-sensitive data" do
          it "should allow to edit certain data without entering a password" do
            visit edit_user_registration_path user

            select I18n.t('common.title.woman'), from: 'user_title'
            fill_in 'user_forename', with: 'Forename'
            fill_in 'user_surname', with: 'Surname'
            select 'Deutschland', from: 'user_country'
            fill_in 'user_street', with: 'User Street 1'
            fill_in 'user_address_suffix', with: 'c/o Bruce Wayne'
            fill_in 'user_city', with: 'Gotham City'
            fill_in 'user_zip', with: '12345'
            fill_in 'user_phone', with: '0123 4567890-1'
            fill_in 'user_mobile', with: '0123 456 78901'
            fill_in 'user_fax', with: '0123 4567890-2'
            fill_in 'user_about_me', with: 'Foobar Bazfuz stuff and junk.'

            click_button I18n.t 'formtastic.actions.update'

            user.reload.title.should eq I18n.t('common.title.woman')
            user.forename.should eq 'Forename'
            user.surname.should eq 'Surname'
            user.country.should eq 'Deutschland'
            user.street.should eq 'User Street 1'
            user.address_suffix.should eq 'c/o Bruce Wayne'
            user.city.should eq 'Gotham City'
            user.zip.should eq '12345'
            user.phone.should eq '0123 4567890-1'
            user.mobile.should eq '0123 456 78901'
            user.fax.should eq '0123 4567890-2'
            user.about_me.should eq 'Foobar Bazfuz stuff and junk.'

            current_path.should eq user_path user
          end
        end

        context "updating sensitive data" do
          before do
            visit edit_user_registration_path user
            select 'Herr', from: 'user_title' # remove this line when possible
            select 'Deutschland', from: 'user_country' # remove this line when possible
          end

          describe '(email)' do
            before { fill_in 'user_email', with: 'chunky@bacon.com' }

            it "should not update a users email without a password" do
              click_button I18n.t 'formtastic.actions.update'

              page.should_not have_content I18n.t 'devise.registrations.updated'
              user.reload.unconfirmed_email.should_not == 'chunky@bacon.com'
            end

            it "should update a users email with a password" do
              fill_in 'user_current_password', with: 'password'
              click_button I18n.t 'formtastic.actions.update'

              page.should have_content I18n.t 'devise.registrations.changed_email'
              user.reload.unconfirmed_email.should == 'chunky@bacon.com'
            end
          end

          describe "(password)" do
            before do
              fill_in 'user_password', with: 'changedpassword'
              fill_in 'user_password_confirmation', with: 'changedpassword'
            end
            it "should disallow editing critical data without a password" do
              click_button I18n.t 'formtastic.actions.update'

              user.reload.valid_password?('changedpassword').should be_false

              within '#user_current_password_input' do
                page.should have_css 'p.inline-errors', text: I18n.t('errors.messages.blank')
              end
            end

            it "should succeed when editing critical data with a password" do
              fill_in 'user_current_password', with: 'password'
              click_button I18n.t 'formtastic.actions.update'

              user.reload.valid_password?('changedpassword').should be_true

              page.should have_content I18n.t 'devise.registrations.updated'
            end
          end
        end
      end

      context "for legal entities" do
        let(:user) { FactoryGirl.create :legal_entity }
        it "should show the correct specific data and fields" do
          login_as user
          visit edit_user_registration_path user
          page.should have_css 'h3', text: I18n.t('users.form_titles.contact_person')

          # Legal fields
          within '#terms_step' do # id of input step
            page.should have_css 'a', text: I18n.t('formtastic.input_steps.user.terms')
            page.should have_content I18n.t 'formtastic.labels.user.terms'
            page.should have_content I18n.t 'formtastic.labels.user.cancellation'
            page.should have_content I18n.t 'formtastic.labels.user.about'
          end
        end

        it "should update the specific fields" do
          login_as user
          visit edit_user_registration_path user
          fill_in 'user_terms', with: 'foobar'
          fill_in 'user_cancellation', with: 'foobar'
          fill_in 'user_about', with: 'foobar'

          click_button I18n.t 'formtastic.actions.update'
          user.reload.terms.should eq 'foobar'
          user.cancellation.should eq 'foobar'
          user.about.should eq 'foobar'
        end
      end

      context "for private users" do
        let(:user) { FactoryGirl.create :private_user }
        it "should not show the legal_user's specific data and fields" do
          login_as user
          visit edit_user_registration_path user

          page.should_not have_css 'h3', text: I18n.t('users.form_titles.contact_person')

          # Legal fields
          within '#edit_user' do # id of the form
            page.should_not have_css 'h3', text: I18n.t('formtastic.input_steps.user.terms')
            page.should_not have_content I18n.t 'formtastic.labels.user.terms'
            page.should_not have_content I18n.t 'formtastic.labels.user.cancellation'
            page.should_not have_content I18n.t 'formtastic.labels.user.about'
          end
        end
      end
    end
  end
end
