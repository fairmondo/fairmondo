#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

include Warden::Test::Helpers

feature 'User profile page' do
  scenario 'user visits his profile' do
    @user = create :user
    login_as @user
    visit user_path(@user)
    page.must_have_content('Profil bearbeiten')
    page.must_have_content('Sammlungen')
    page.wont_have_content('Admin')
  end

  scenario 'user looks at his profile' do
    @user = create :user
    login_as @user
    visit profile_user_path(@user)
    page.must_have_content @user.nickname
  end

  scenario 'guest visits another users profile through an article' do
    article = create :article
    visit article_path article
    find('.User-image a').click
    current_path.must_equal user_path article.seller
  end

  scenario "guests visits a legal entity's profile page" do
    user = create :legal_entity
    visit user_path user
    click_link I18n.t 'common.text.about_terms_short'
    current_path.must_equal profile_user_path user
  end
end

feature 'contacting users' do
  before do
    receiver = create :legal_entity
    sender   = create :user
    login_as sender
    visit profile_user_path receiver

    within('.user-menu') do
      click_link I18n.t 'users.profile.contact.heading'
    end
  end

  scenario 'user contacts seller' do
    within('#contact_form') do
      fill_in 'contact_form[text]', with: 'foobar'
      click_button I18n.t('article.show.contact.action')
    end
    page.must_have_content I18n.t 'users.profile.contact.success_notice'
  end
end
