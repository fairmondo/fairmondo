#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class LibraryAdminManagementTest < ApplicationSystemTestCase
  let(:featured_library) { create :library, :public, exhibition_name: 'donation_articles' }
  let(:article) { create :article, title: 'Foobar' }
  setup do
    sign_in create :admin_user
  end

  test 'admin adds Article to a random Library' do
    visit root_path
    page.wont_have_link 'Foobar'

    featured_library
    visit article_path article
    select(I18n.t('enumerize.library.exhibition_name.donation_articles'), from: 'library_exhibition_name')
    click_button I18n.t 'article.show.add_as_exhibit'

    visit root_path
    page.must_have_link 'Foobar'
  end

  test 'admin add Article that is already in the library' do
    featured_library.articles << article
    visit article_path article
    select(I18n.t('enumerize.library.exhibition_name.donation_articles'), from: 'library_exhibition_name')

    assert_no_difference 'featured_library.articles.count' do
      click_button I18n.t 'article.show.add_as_exhibit'
    end
  end

  test 'admin removes an article' do
    featured_library.articles << article
    visit article_path article

    click_button 'aus *Spendenanteil*-Artikel löschen'
    visit root_path

    page.wont_have_link 'Foobar'
  end

  test 'admin sets a library as featured' do
    featured_library
    other_library = create :library, :public

    visit library_path other_library
    select(I18n.t('enumerize.library.exhibition_name.donation_articles'), from: 'library_exhibition_name')
    find('#select_exhibition_submit_action').click

    other_library.reload.exhibition_name.must_equal 'donation_articles'
    assert_nil featured_library.reload.exhibition_name
  end
end
