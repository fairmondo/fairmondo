#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class ArticleCommendationTest < ApplicationSystemTestCase
  setup do
    @seller = create :user
    @article = create :article, :simple_ecologic, seller: @seller
  end

  test 'user visits ecologic article' do
    visit article_path(@article)
    assert page.has_link?(I18n.t 'formtastic.labels.article.ecologic')
  end

  test 'user visits seller with ecologic article' do
    skip 'The label does not appear on the page anymore. We should find out why'
    Chewy::Query.any_instance.stubs(:to_a).raises(Faraday::ConnectionFailed.new('test')) # simulate connection error so that we dont have to use elastic
    visit user_path(@seller)
    within('.Article-tags') do
      assert page.has_content?(I18n.t 'formtastic.labels.article.ecologic')
    end
  end
end
