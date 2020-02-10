#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class AddToCartTest < ApplicationSystemTestCase
  test 'anonymous user adds article to his cart' do
    article = create(:article, title: 'foobar')
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page_must_include_notice_for(article)
    click_link(I18n.t('header.cart.title', count: 1), match: :first)
    assert page.has_content? 'foobar'
  end

  test 'logged-in user adds article to his cart' do
    article = create(:article, title: 'foobar')
    sign_in create(:user)
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page_must_include_notice_for(article)
    click_link(I18n.t('header.cart.title', count: 1), match: :first)
    assert page.has_content? 'foobar'
  end

  test 'logged-in user adds article to his cart and is logged out by the system' do
    article = create(:article, title: 'foobar')
    user = create(:user)
    sign_in user
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page_must_include_notice_for(article)
    logout(:user) # simulate logout
    visit root_path
    _(page).wont_have_content I18n.t('header.cart.title', count: 1)
    sign_in create(:user)
    _(page).wont_have_content I18n.t('header.cart.title', count: 1)
    _(Cart.last.user).must_equal user
  end

  test 'logged-in user adds article to his cart and logs out' do
    article = create(:article, title: 'foobar')
    user = create(:user)
    sign_in user
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page_must_include_notice_for(article)

    within '.l-header-nav' do
      click_link I18n.t('common.actions.logout')
    end

    _(page).wont_have_content I18n.t('header.cart.title', count: 1)
    sign_in create(:user)
    _(page).wont_have_content I18n.t('header.cart.title', count: 1)
    _(Cart.last.user).must_equal user
  end

  test 'logged-in user adds article twice to his cart' do
    article = create(:article)
    sign_in create(:user)
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page_must_include_notice_for(article)
    _(page).wont_have_content I18n.t('common.actions.to_cart')
    _(Cart.last.line_items.count).must_equal 1
    _(Cart.last.line_items.first.requested_quantity).must_equal 1
  end

  test 'logged-in user adds article that is available in quantity >= 2 twice to to his cart' do
    article = create(:article, :with_larger_quantity)
    sign_in create(:user)
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page_must_include_notice_for(article)
    click_button I18n.t('common.actions.to_cart')
    page_must_include_notice_for(article)
    _(Cart.last.line_items.count).must_equal 1
    _(Cart.last.line_items.first.requested_quantity).must_equal 2
  end

  test 'logged-in user adds article that is available in quantity >= 2 twice to to his cart and requests more than available' do
    article = create(:article, :with_larger_quantity)
    sign_in create(:user)
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page_must_include_notice_for(article)
    fill_in 'line_item_requested_quantity', with: article.quantity
    click_button I18n.t('common.actions.to_cart')
    _(page.html).must_include I18n.t('line_item.notices.error_quantity')
    _(Cart.last.line_items.count).must_equal 1
    _(Cart.last.line_items.first.requested_quantity).must_equal 1
  end

  def page_must_include_notice_for(article)
    cart = article.line_items.first.cart
    _(page.html).must_include I18n.t('line_item.notices.success_create', href: "/carts/#{cart.id}").html_safe
  end
end
