#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class LibraryVisibilityTest < ApplicationSystemTestCase
  before do
    UserTokenGenerator.stubs(:generate).returns('some long string that is very secret')
  end
  test 'user browses through libraries' do
    user = create :user
    pub_lib = create :library, user: user, public: true
    pub_lib.articles << create(:article, title: 'exhibit-article')
    priv_lib = create :library, user: user, public: false
    visit user_libraries_path user
    assert page.has_content? pub_lib.name
    page.wont_have_content priv_lib.name
  end
end
