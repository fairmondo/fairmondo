#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class UserProfilePageTest < ApplicationSystemTestCase
  test 'user visits his profile' do
    @user = create :user
    login_as @user
    visit user_path(@user)
    page.must_have_content('Profil bearbeiten')
    page.must_have_content('Sammlungen')
    page.wont_have_content('Admin')
  end

  test 'user looks at his profile' do
    @user = create :user
    login_as @user
    visit profile_user_path(@user)
    page.must_have_content @user.nickname
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
    current_path.must_equal profile_user_path user
  end
end
