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

feature 'Hearts for not-logged-in users' do
  before do
    UserTokenGenerator.stubs(:generate).returns('some long string that is very secret')
  end

  scenario 'User visits library path, finds no hearts, ' +
           'then likes a library and finds his heart' do
    library = FactoryGirl.create(:library_with_elements, public: true)

    visit library_path(library.id)
    page.must_have_selector('.Hearts-button')
    within('.Hearts-button em') { page.must_have_content '0' }

    # can't check JS (otherwise this would be click_link, wait...)
    library.hearts.create(user_token: 'RandomUserToken')
    visit library_path(library.id)
    within('.Hearts-button em') { page.must_have_content '1' }
  end
end

feature 'Hearts for logged-in users' do
  scenario 'User visits library path, finds no hearts, ' +
           'then likes a library and finds his heart' do
    user = FactoryGirl.create(:user)
    library = FactoryGirl.create(:library_with_elements, public: true)
    login_as user

    visit library_path(library.id)
    page.must_have_selector('.Hearts-button')
    within('.Hearts-button em') { page.must_have_content '0' }

    h = user.hearts.create(heartable: library) # can't check JS
    visit library_path(library.id)
    within('.Hearts-button em') { page.must_have_content '1' }

    h.destroy # can't check JS
    visit library_path(library.id)
    within('.Hearts-button em') { page.must_have_content '0' }
  end
end
