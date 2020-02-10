#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class ArticleBuyTest < ApplicationSystemTestCase
  setup do
    @article = create :article
  end
  test 'user clicks buy button' do
    user = create :user
    sign_in user

    visit article_path @article
    click_button I18n.t 'common.actions.to_cart'
    current_path.must_equal article_path @article
  end

  test 'guest clicks buy button' do
    visit article_path @article
    click_button I18n.t 'common.actions.to_cart'
    current_path.must_equal article_path @article
  end
  # add more
end
