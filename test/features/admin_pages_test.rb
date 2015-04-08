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
    page.must_have_content('Admin')
    click_on 'Admin'
    page.must_have_content('Administration')
  end
end
