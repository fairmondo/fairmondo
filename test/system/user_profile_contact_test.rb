#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class UserProfileContactTest < ApplicationSystemTestCase
  before do
    receiver = create :legal_entity
    sender   = create :user
    sign_in sender
    visit profile_user_path receiver

    within('.user-menu') do
      click_link I18n.t 'users.profile.contact.heading'
    end
  end

  test 'user contacts seller' do
    within('#contact_form') do
      fill_in 'contact_form[text]', with: 'foobar'
      click_button I18n.t('article.show.contact.action')
    end
    assert page.has_content? I18n.t 'users.profile.contact.success_notice'
  end
end
