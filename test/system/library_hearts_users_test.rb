#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class LibraryHeartsUsersTest < ApplicationSystemTestCase
  test 'User visits library path, finds no hearts, ' +
       'then likes a library and finds his heart' do
    user = create(:user)
    library = create(:public_library_with_elements)
    sign_in user

    visit library_path(library.id)
    page.must_have_selector('.Hearts-button')
    within('.Hearts-button em') { assert page.has_content? '0' }

    h = user.hearts.create(heartable: library) # can't check JS
    visit library_path(library.id)
    within('.Hearts-button em') { assert page.has_content? '1' }

    h.destroy # can't check JS
    visit library_path(library.id)
    within('.Hearts-button em') { assert page.has_content? '0' }
  end
end
