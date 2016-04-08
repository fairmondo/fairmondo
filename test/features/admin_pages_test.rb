#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

include Warden::Test::Helpers

feature 'AdminPages' do
  before do
    @admin = create(:admin_user)
    login_as @admin
    visit root_path
  end

  scenario 'gets redirected to Admin Dashboard' do
    page.must_have_content I18n.t('layouts.partials.header_nav.admin.title')
    within '.l-header-nav' do
      click_on I18n.t('layouts.partials.header_nav.admin.backend')
    end
    page.must_have_content('Administration')
  end

  scenario 'can change user slug' do
    user = create(:user)
    visit edit_admin_user_path(user.id)
    page.must_have_field('user_slug')
  end
end
