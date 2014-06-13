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
require 'test_helper'

include Warden::Test::Helpers

describe 'ActiveAdminPages' do

  describe 'for non-admin users' do

    before :each do
      @user = FactoryGirl.create(:user)
      login_as @user
    end

  end

  describe 'for admin users' do
    before :each do
      @admin = FactoryGirl.create(:admin_user)
      login_as @admin
      visit root_path
    end

    it 'shows the Admin link' do
      page.should have_content('Admin')
    end

    before :each do
      click_on 'Admin'
    end

    it 'gets redirected to Admin Dashboard' do
      page.should have_content('Administration')
    end

  end
end
