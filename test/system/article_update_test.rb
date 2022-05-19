#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class ArticleUpdateTest < ApplicationSystemTestCase
  before do
    user = create :user
    @article = create :preview_article, seller: user
    sign_in user
    visit edit_article_path @article
  end

  test 'user edits title' do
    fill_in 'article_title', with: 'foobar'
    click_button I18n.t 'article.labels.continue_to_preview'

    @article.reload.title.must_equal 'foobar'
    current_path.must_equal article_path @article
  end

  test 'refills the stock' do
    @article.update_attribute(:quantity_available, 0)
    fill_in 'article_quantity', with: 20
    click_button I18n.t 'article.labels.continue_to_preview'

    @article.reload.quantity.must_equal 20
    @article.quantity_available_without_article_state.must_equal 20
    current_path.must_equal article_path @article
  end
end
