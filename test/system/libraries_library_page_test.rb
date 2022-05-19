#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class LibrariesLibraryPageTest < ApplicationSystemTestCase
  test 'more libraries of the same user are shown on a library page' do
    user = create :user
    library1 = create(:public_library_with_elements, user: user)
    library2 = create(:public_library_with_elements, user: user)

    visit library_path(library1)
    assert page.has_content?(library2.name)
  end
end
