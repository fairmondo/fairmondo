#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class ArticleRecommendationTest < ApplicationSystemTestCase
  setup do
    seller = create :user
    ArticlesIndex.reset!
    @article = create :article, :index_article, seller: seller
    @article_active = create :article, :index_article, seller: seller
    @article_locked = create :preview_article, :index_article, seller: seller
  end

  test 'user wants to see other articles of the same seller' do
    visit article_path @article
    assert page.has_link?('', href: article_path(@article_active))
    page.wont_have_link('', href: article_path(@article_locked))
  end
end
