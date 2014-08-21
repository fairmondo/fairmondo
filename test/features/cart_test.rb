require_relative '../test_helper'

include Warden::Test::Helpers

feature 'Adding an Article to the cart' do

  scenario 'anonymous user adds articles to his cart' do
    article = FactoryGirl.create(:article, title: 'foobar')
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    click_link I18n.t('header.cart', count: 1)
    page.must_have_content 'foobar'
  end

  scenario 'logged-in user adds articles to his cart' do
    article = FactoryGirl.create(:article, title: 'foobar')
    login_as FactoryGirl.create(:user)
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    click_link I18n.t('header.cart', count: 1)
    page.must_have_content 'foobar'
  end

end

feature 'Checkout' do
  scenario 'Buying a cart with one item (default)' do

    article = FactoryGirl.create(:article, title: 'foobar')
    login_as FactoryGirl.create(:user)
    visit article_path(article)

    # add things to cart ( hard to generate this via factory because it is kinda hard to set a signed cookie in capybara )

    click_button I18n.t('common.actions.to_cart')
    click_link I18n.t('header.cart', count: 1)

    # Step 1

    click_link I18n.t('cart.actions.checkout')
    page.check('cart_checkout_form_line_item_groups_1_tos_accepted')

    # Step 2

    click_button I18n.t('common.actions.continue')
    page.find('.payment-cell.total:last').must_have_content(article.price + article.transport_type1_price)

    # checkout

    CartMailer.expects(:seller_email)
    CartMailer.expects(:buyer_email)
    find('input.checkout_button').click

  end

end


