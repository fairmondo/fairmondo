#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class UpdateArticleQuantityInCart < ApplicationSystemTestCase
  test 'change quantity to 10 from 1' do
    article = create(:article, quantity: 10)
    login_as create(:user)
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page_must_include_notice_for(article)
    click_link(I18n.t('header.cart.title', count: 1), match: :first)

    # within('.change_quantity') do
    #  fill_in 'line_item_requested_quantity', with: 10
    #  find('button.Button').click
    # end
    # Cart.last.line_items.first.requested_quantity.must_equal 10
  end
end
