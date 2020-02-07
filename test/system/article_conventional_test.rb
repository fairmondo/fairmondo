#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class ArticleConventionalTest < ApplicationSystemTestCase
  before do
    @seller = create :user, type: 'LegalEntity'
    @article_conventional = create :no_second_hand_article, seller: @seller
  end

  test 'user visits an article' do
    visit article_path @article_conventional
    assert page.has_link?('Transparency International', href: 'http://www.transparency.de/')
  end

  test 'user visits article list' do
    visit articles_path
  end

  test 'user opens a conventional article from a user that is whitelisted' do
    EXCEPTIONS_ON_FAIRMONDO['no_fair_alternative']['user_ids'] = [@seller.id]
    visit article_path @article_conventional
    page.assert_no_selector('div.fair_alternative')
  end
end
