#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class ArticleActivationLegalEntitiesTest < ApplicationSystemTestCase
  let(:user) { create :legal_entity }
  let(:article) { create :preview_article, seller: user }

  test 'legal entity adds goods for more than 5000000' do
    6.times { create :article, seller: user, price_cents: 1000000 }
    sign_in user
    visit article_path(article)
    click_button I18n.t('article.labels.submit')
    assert page.has_content? I18n.t('article.notices.max_limit')
    article.active?.must_equal false
  end

  test "user doesn't accept TOS" do
    sign_in user
    visit article_path(article)
    click_button I18n.t('article.labels.submit')
    assert page.has_content? I18n.t('article.notices.activation_failed')
    current_path.must_equal article_path article
    article.reload.active?.must_equal false
  end
end
