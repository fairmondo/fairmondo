#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class LibraryFeaturedTest < ApplicationSystemTestCase
  test 'user visits root path with exhibition' do
    lib = create :library, :public, exhibition_name: 'donation_articles'
    lib.articles << create(:article, title: 'exhibit-article')
    visit root_path
    assert page.has_content? 'exhibit-article'
  end

  test 'user visits book category front page' do
    lib = create :library, :public, exhibition_name: 'book1'
    lib.articles << create(:article, title: 'exhibit-article')
    visit category_path create :category, name: 'bucher'
    assert page.has_content? 'exhibit-article'
  end

  test 'user visits two filter landing pages' do
    article = create :article, title: 'exhibit-article'
    lib1 = create :library, :public, exhibition_name: 'fair1'
    lib2 = create :library, :public, exhibition_name: 'used1'
    lib1.articles << article
    lib2.articles << article

    visit root_path
    find('#filter-fair').find('a').click
    assert page.has_content? 'exhibit-article'

    visit root_path
    find('#filter-used').find('a').click
    assert page.has_content? 'exhibit-article'
  end
end
