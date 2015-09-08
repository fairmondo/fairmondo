#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
require_relative '../test_helper'

include Warden::Test::Helpers

feature 'AdminPages' do
  before do
    @admin = FactoryGirl.create(:admin_user)
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
    user = FactoryGirl.create(:user)
    visit edit_admin_user_path(user.id)
    page.must_have_field('user_slug')
  end
end
