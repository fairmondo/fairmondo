#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

include Warden::Test::Helpers

feature 'Hearts for not-logged-in users' do
  before do
    UserTokenGenerator.stubs(:generate).returns('some long string that is very secret')
  end

  scenario 'User visits library path, finds no hearts, ' +
           'then likes a library and finds his heart' do
    library = create(:public_library_with_elements)

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
    user = create(:user)
    library = create(:public_library_with_elements)
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
