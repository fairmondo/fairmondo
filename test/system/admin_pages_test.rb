#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class AdminPagesTest < ApplicationSystemTestCase
  before do
    @admin = create(:admin_user)
    sign_in @admin
    visit root_path
  end

  test 'gets redirected to Admin Dashboard' do
    within '.l-header-nav' do
      click_on I18n.t('layouts.partials.header_nav.admin.backend')
    end
    assert page.has_content?('Administration')
  end

  test 'can change user slug' do
    user = create(:user)
    visit edit_admin_user_path(user.id)
    page.must_have_field('user_slug')
  end
end
