#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class UserAccountManagementTest < ApplicationSystemTestCase
  test 'user updates his profile' do
    user = create :user
    login_as user

    visit edit_user_registration_path user
    # Heading
    page.must_have_css 'h1', text: I18n.t('common.actions.edit_profile')

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
    page.must_have_content I18n.t 'formtastic.labels.user.newsletter'
    page.must_have_content I18n.t 'formtastic.labels.user.receive_comments_notification'

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

  test 'user wants to change the email for his account' do
    @user = create :user
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

  test 'user wants to change the email for account without a password' do
    @user = create :user
    login_as @user
    visit edit_user_registration_path @user
    fill_in 'user_email', with: 'chunky@bacon.com'
    click_button I18n.t 'formtastic.actions.update'
    page.wont_have_content I18n.t 'devise.registrations.updated'
    @user.reload.unconfirmed_email.wont_equal 'chunky@bacon.com'
  end

  test 'user wants to change the password for his account without having address' do
    @user = create :incomplete_user
    login_as @user
    visit edit_user_registration_path @user
    fill_in 'user_current_password', with: 'password'
    fill_in 'user_password', with: 'changedpassword'
    fill_in 'user_password_confirmation', with: 'changedpassword'
    click_button I18n.t 'formtastic.actions.update'
    @user.reload.valid_password?('changedpassword').must_equal true
    page.must_have_content I18n.t 'devise.registrations.updated'
  end

  test 'user wants to change the password for account without current password' do
    @user = create :user
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

  test 'legal entity wants to update terms/cancelation/about' do
    user = create :legal_entity
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

  test 'legal entity fills in alternative email addresses' do
    user = create :legal_entity, invoicing_email: '', order_notifications_email: ''

    user.email_for_invoicing.must_equal user.email
    user.email_for_order_notifications.must_equal user.email

    login_as user
    visit edit_user_registration_path user

    fill_in 'user_invoicing_email', with: 'invoices@example.com'
    fill_in 'user_order_notifications_email', with: 'orders@example.com'

    click_button I18n.t('formtastic.actions.update')

    user.reload
    user.email_for_invoicing.must_equal 'invoices@example.com'
    user.email_for_order_notifications.must_equal 'orders@example.com'
  end

  test 'private user wants to edit his account' do
    @user =  create :private_user
    login_as @user
    visit edit_user_registration_path @user
    page.wont_have_css 'h3', text: I18n.t('users.form_titles.contact_person')

    within '#edit_user' do # id of the form
      page.wont_have_css 'h3', text: I18n.t('formtastic.input_steps.user.terms')
      page.wont_have_content I18n.t 'formtastic.labels.user.terms'
      page.wont_have_content I18n.t 'formtastic.labels.user.cancellation'
      page.wont_have_content I18n.t 'formtastic.labels.user.about'

      page.wont_have_css '#alternative_emails_step'
    end
  end
end
