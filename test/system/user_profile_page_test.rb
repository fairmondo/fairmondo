#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class UserProfilePageTest < ApplicationSystemTestCase
  test 'user visits his profile' do
    @user = create :user
    sign_in @user
    visit user_path(@user)
    assert page.has_content?('Profil bearbeiten')
    assert page.has_content?('Sammlungen')
    refute page.has_content?('Admin')
  end

  test 'user looks at his profile' do
    @user = create :user
    sign_in @user
    visit profile_user_path(@user)
    assert page.has_content? @user.nickname
  end

  test 'guest visits another users profile through an article' do
    article = create :article
    visit article_path article
    find('.User-image a').click
    current_path.must_equal user_path article.seller
  end

  test "guests visits a legal entity's profile page" do
    user = create :legal_entity
    visit user_path user
    click_link I18n.t 'common.text.about_terms_short'
    assert_equal profile_user_path(user), current_path
  end
end
