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
# You must_have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require_relative '../test_helper'
include FastBillStubber

include Warden::Test::Helpers

feature 'User registration' do

  scenario "user visits root path and signs in" do
    user = FactoryGirl.create :user
    stub_fastbill #for user update calls
    visit root_path

    page.must_have_link I18n.t('common.actions.login')
    click_link I18n.t('common.actions.login')

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'
    click_button I18n.t('formtastic.actions.login')

    page.must_have_content I18n.t 'devise.sessions.signed_in'
  end

  scenario "guest registers a new user" do
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
    assert_difference 'User.count', 1 do
      click_button 'sign_up'
    end
  end

  scenario "banned user wants to sing in" do
    user = FactoryGirl.create :user, banned: true
    FactoryGirl.create :content, key:'banned', body: '<p>You are banned.</p>'
    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'
    click_button I18n.t('formtastic.actions.login')

    page.must_have_content 'You are banned.'
    page.wont_have_content I18n.t 'devise.sessions.signed_in'
  end
end

feature "User account management" do
  scenario "user updates his profile" do
    user = FactoryGirl.create :user
    login_as user

    visit edit_user_registration_path user
    # Heading
    page.must_have_css "h1", text: I18n.t('common.actions.edit_profile')

    # Account Data
    page.must_have_content I18n.t 'formtastic.labels.user.legal_entity'
    page.must_have_content I18n.t 'formtastic.labels.user.nickname'
    page.must_have_content user.nickname
    page.must_have_content I18n.t 'formtastic.labels.user.customer_number'
    page.must_have_content user.customer_nr
    page.must_have_content I18n.t 'formtastic.labels.user.image'

    # Account Fields
    page.must_have_css 'h3', text: I18n.t('users.title.login')
    page.must_have_content I18n.t 'formtastic.labels.user.email'
    page.must_have_content I18n.t 'users.change_password'
    page.must_have_content I18n.t 'formtastic.labels.user.password'
    page.must_have_content I18n.t 'formtastic.labels.user.current_password'

    # State Fields
    page.must_have_css 'h3', text: I18n.t('users.title.state')
    page.must_have_content I18n.t 'formtastic.labels.user.vacationing'

    # Contact Info Fields
    page.must_have_content I18n.t 'formtastic.labels.address.title'
    page.must_have_content I18n.t 'formtastic.labels.address.first_name'
    page.must_have_content I18n.t 'formtastic.labels.address.last_name'
    page.must_have_content I18n.t 'formtastic.labels.address.country'
    page.must_have_content I18n.t 'formtastic.labels.address.address_line_1'
    page.must_have_content I18n.t 'formtastic.labels.address.address_line_2'
    page.must_have_content I18n.t 'formtastic.labels.address.city'
    page.must_have_content I18n.t 'formtastic.labels.address.zip'
    page.must_have_content I18n.t 'formtastic.labels.user.phone'
    page.must_have_content I18n.t 'formtastic.labels.user.mobile'
    page.must_have_content I18n.t 'formtastic.labels.user.fax'

    # Profile Fields
    page.must_have_content I18n.t 'formtastic.labels.user.about_me'

    page.must_have_button I18n.t 'formtastic.actions.update'

    select I18n.t('common.title.woman'), from: 'address_title'
    fill_in 'address_first_name', with: 'Forename'
    fill_in 'address_last_name', with: 'Surname'
    select 'Deutschland', from: 'address_country'
    fill_in 'address_address_line_1', with: 'User Street 1'
    fill_in 'address_address_line_2', with: 'c/o Bruce Wayne'
    fill_in 'address_city', with: 'Gotham City'
    fill_in 'address_zip', with: '12345'
    fill_in 'user_phone', with: '0123 4567890-1'
    fill_in 'user_mobile', with: '0123 456 78901'
    fill_in 'user_fax', with: '0123 4567890-2'
    fill_in 'user_about_me', with: 'Foobar Bazfuz stuff and junk.'

    click_button I18n.t 'formtastic.actions.update'

    user.reload
    user.standard_address.reload
    user.standard_address_title.must_equal I18n.t('common.title.woman')
    user.standard_address_first_name.must_equal 'Forename'
    user.standard_address_last_name.must_equal 'Surname'
    user.standard_address_country.must_equal 'Deutschland'
    user.standard_address_address_line_1.must_equal 'User Street 1'
    user.standard_address_address_line_2.must_equal 'c/o Bruce Wayne'
    user.standard_address_city.must_equal 'Gotham City'
    user.standard_address_zip.must_equal '12345'
    user.phone.must_equal '0123 4567890-1'
    user.mobile.must_equal '0123 456 78901'
    user.fax.must_equal '0123 4567890-2'
    user.about_me.must_equal 'Foobar Bazfuz stuff and junk.'

    current_path.must_equal user_path user
  end

  scenario "user wants to change the email for his account" do
    @user = FactoryGirl.create :user
    login_as @user
    visit edit_user_registration_path @user
    select 'Herr', from: 'address_title'
    select 'Deutschland', from: 'address_country'
    fill_in 'user_email', with: 'chunky@bacon.com'
    fill_in 'user_current_password', with: 'password'
    click_button I18n.t 'formtastic.actions.update'

    page.must_have_content I18n.t 'devise.registrations.changed_email'
    @user.reload.unconfirmed_email.must_equal 'chunky@bacon.com'

  end

  scenario "user wants  to change the email for account without a password" do
    @user = FactoryGirl.create :user
    login_as @user
    visit edit_user_registration_path @user
    fill_in 'user_email', with: 'chunky@bacon.com'
    click_button I18n.t 'formtastic.actions.update'
    page.wont_have_content I18n.t 'devise.registrations.updated'
    @user.reload.unconfirmed_email.wont_equal 'chunky@bacon.com'
  end

  scenario "user wants to change the password for his account" do
    @user = FactoryGirl.create :user
    login_as @user
    visit edit_user_registration_path @user
    select 'Herr', from: 'address_title'
    select 'Deutschland', from: 'address_country'
    fill_in 'user_current_password', with: 'password'
    fill_in 'user_password', with: 'changedpassword'
    fill_in 'user_password_confirmation', with: 'changedpassword'
    click_button I18n.t 'formtastic.actions.update'
    @user.reload.valid_password?('changedpassword').must_equal true
    page.must_have_content I18n.t 'devise.registrations.updated'

  end

  scenario "user wantsto change the password for account without current password" do
    @user = FactoryGirl.create :user
    login_as @user
    visit edit_user_registration_path @user
    fill_in 'user_password', with: 'changedpassword'
    fill_in 'user_password_confirmation', with: 'changedpassword'
    click_button I18n.t 'formtastic.actions.update'
    @user.reload.valid_password?('changedpassword').must_equal false
    within '#user_current_password_input' do
      page.must_have_css 'p.inline-errors', text: I18n.t('errors.messages.blank')
    end
  end

  scenario "legal entity wants to update terms/cancelation/about" do
    user = FactoryGirl.create :legal_entity
    login_as user
    visit edit_user_registration_path @user
    page.must_have_css 'h3', text: I18n.t('users.form_titles.contact_person')

    # Legal fields
    within '#terms_step' do # id of input step
      page.must_have_css 'a', text: I18n.t('formtastic.input_steps.user.terms')
      page.must_have_content I18n.t 'formtastic.labels.user.terms'
      page.must_have_content I18n.t 'formtastic.labels.user.cancellation'
      page.must_have_content I18n.t 'formtastic.labels.user.about'
    end

    fill_in 'user_terms', with: 'foobar'
    fill_in 'user_cancellation', with: 'foobar'
    fill_in 'user_about', with: 'foobar'

    click_button I18n.t 'formtastic.actions.update'
    user.reload.terms.must_equal 'foobar'
    user.cancellation.must_equal 'foobar'
    user.about.must_equal 'foobar'

  end

  scenario "private user wants to edit his account" do
    @user =  FactoryGirl.create :private_user
    login_as @user
    visit edit_user_registration_path @user
    page.wont_have_css 'h3', text: I18n.t('users.form_titles.contact_person')


    within '#edit_user' do # id of the form
      page.wont_have_css 'h3', text: I18n.t('formtastic.input_steps.user.terms')
      page.wont_have_content I18n.t 'formtastic.labels.user.terms'
      page.wont_have_content I18n.t 'formtastic.labels.user.cancellation'
      page.wont_have_content I18n.t 'formtastic.labels.user.about'
    end
  end
end


feature "Newsletter" do
  setup do
    @user = FactoryGirl.create :user
    login_as @user
  end
  scenario "user wants to receive newsletter" do

    fixture = File.read("test/fixtures/cleverreach_add_success.xml")
    savon.expects(:receiver_add).with(message: :any).returns(fixture)

    visit edit_user_registration_path @user
    check 'user_newsletter'
    click_button I18n.t 'formtastic.actions.update'

    @user.reload.newsletter.must_equal true
  end
  scenario "user wants to unsubscribe to the newsletter" do

    fixture = File.read("test/fixtures/cleverreach_remove_success.xml")
    savon.expects(:receiver_delete).with(message: :any).returns(fixture)

    @user.update_column :newsletter, true
    visit edit_user_registration_path @user
    uncheck 'user_newsletter'
    click_button I18n.t 'formtastic.actions.update'

    @user.reload.newsletter.must_equal false
  end
end




