#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class UserRegistrationTest < ApplicationSystemTestCase
  test 'user visits root path and signs in' do
    user = create :user
    visit root_path

    # Check movile nav as well as desktop nav
    within '.l-header-mnav' do
      page.must_have_link I18n.t('common.actions.login')
    end
    within '.l-header-nav' do
      page.must_have_link I18n.t('common.actions.login')
      click_link I18n.t('common.actions.login')
    end

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'
    click_button I18n.t('formtastic.actions.login')

    assert page.has_content? I18n.t 'devise.sessions.signed_in'
  end

  test 'guest registers a new user' do
    visit new_user_registration_path

    within '#registration_form' do
      fill_in 'user_nickname',              with: 'nickname'
      fill_in 'user_email',                 with: 'email@example.com'
      fill_in 'user_password',              with: 'password'
      check 'user_type', allow_label_click: true
      choose 'user_voluntary_contribution_5', allow_label_click: true
      check 'user_legal', allow_label_click: true
    end
    assert_difference 'User.count', 1 do
      click_button 'sign_up'
    end

    assert_equal 5, User.last.voluntary_contribution
  end
end
