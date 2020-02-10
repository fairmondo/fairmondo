#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class ArticleActivationPrivateUsersTest < ApplicationSystemTestCase
  test 'private user adds goods for more than 500000' do
    user = create :private_user
    create :article, seller: user, price_cents: 600000
    article = create :preview_article, user_id: user.id
    sign_in user
    visit article_path(article)
    click_button I18n.t('article.labels.submit_free')
    assert page.has_content? I18n.t('article.notices.max_limit')
    article.active?.must_equal false
  end

  test 'private user with a bonus if 200000 adds goods for more than 500000' do
    user = create :private_user, max_value_of_goods_cents_bonus: 200000
    create :article, seller: user, price_cents: 600000
    article = create :preview_article, seller: user
    sign_in user
    visit article_path(article)
    click_button I18n.t('article.labels.submit_free')
    page.wont_have_content I18n.t('article.notices.max_limit')
    current_path.must_equal article_path article
    article.reload.active?.must_equal true
  end
end
