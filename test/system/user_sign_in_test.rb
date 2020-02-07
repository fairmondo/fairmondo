#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class UserSignInTest < ApplicationSystemTestCase
  test 'banned user wants to sign in' do
    user = create :user, banned: true
    create :content, key: 'banned', body: '<p>You are banned.</p>'
    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'
    click_button I18n.t('formtastic.actions.login')

    assert page.has_content? 'You are banned.'
    refute page.has_content? I18n.t 'devise.sessions.signed_in'
  end

  test 'Legal entity who needs to reaccept direct debit signs in' do
    user = create :legal_entity, direct_debit_exemption: false
    create :article, seller: user
    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'
    click_button I18n.t('formtastic.actions.login')

    assert page.has_content? I18n.t 'devise.sessions.signed_in'
    assert page.has_content? I18n.t 'users.notices.sepa_missing'
    assert_equal '/user/edit', current_path
  end
end
