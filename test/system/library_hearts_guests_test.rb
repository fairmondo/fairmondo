#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class LibraryHeartsGuestsTest < ApplicationSystemTestCase
  before do
    UserTokenGenerator.stubs(:generate).returns('some long string that is very secret')
  end

  test 'User visits library path, finds no hearts, ' +
           'then likes a library and finds his heart' do
    library = create(:public_library_with_elements)

    visit library_path(library.id)
    page.must_have_selector('.Hearts-button')
    within('.Hearts-button em') { assert page.has_content? '0' }

    # can't check JS (otherwise this would be click_link, wait...)
    library.hearts.create(user_token: 'RandomUserToken')
    visit library_path(library.id)
    within('.Hearts-button em') { assert page.has_content? '1' }
  end
end
