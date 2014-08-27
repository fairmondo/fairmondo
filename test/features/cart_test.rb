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
    page.find('.payment-cell.total.value').must_have_content(article.price + article.transport_type1_price)

    # checkout

    CartMailer.expects(:seller_email)
    CartMailer.expects(:buyer_email)
    find('input.checkout_button').click
    Cart.last.sold?.must_equal true

  end

  scenario 'Buying a cart with one item and free transport' do

    seller = FactoryGirl.create :legal_entity, :with_free_transport_at_5
    article = FactoryGirl.create(:article, title: 'foobar', price_cents: 600, seller: seller )
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
    save_and_open_page
    page.find('.payment-cell.total.value').must_have_content(article.price)

    # checkout

    CartMailer.expects(:seller_email)
    CartMailer.expects(:buyer_email)
    find('input.checkout_button').click
    Cart.last.sold?.must_equal true

  end


  scenario 'Buying a cart with items from different users' do

    unified_seller = FactoryGirl.create :legal_entity, :with_unified_transport_information, :paypal_data
    articles = [FactoryGirl.create(:article, :with_all_payments, :with_all_transports, title: 'unified1', seller: unified_seller),
                FactoryGirl.create(:article, :with_all_payments, :with_all_transports, title: 'unified2', seller: unified_seller),
                FactoryGirl.create(:article, :with_all_payments, title: 'single_transport1', seller: unified_seller)]

    single_seller =  FactoryGirl.create :legal_entity, :paypal_data
    articles << FactoryGirl.create(:article, :with_all_payments, :with_all_transports, title: 'single_transport2', seller: single_seller)
    articles << FactoryGirl.create(:article, :with_all_payments, :with_all_transports, title: 'single_transport3', seller: single_seller)

    buyer = FactoryGirl.create(:user)
    login_as buyer

    articles.each do |article|
      visit article_path(article)
      click_button I18n.t('common.actions.to_cart')
    end

    visit cart_path(buyer.carts.last)

    # Step 1

    click_link I18n.t('cart.actions.checkout')

    transport_notices = page.all('.js-unified-transport--inversetarget')
    transport_notices.size.must_equal 3
    transport_notices[0..1].each do |notice|
      notice.must_have_content(I18n.t('cart.texts.unified_transport_notice'))
    end
    transport_notices[2].must_have_content(I18n.t('cart.texts.unified_transport_impossible'))
    page.check('cart_checkout_form_line_item_groups_1_tos_accepted')
    page.check('cart_checkout_form_line_item_groups_2_tos_accepted')

    # Step 2

    click_button I18n.t('common.actions.continue')
    totals = page.all('.payment-cell.total.value')
    #binding.pry
    totals.first.must_have_content(articles[0..2].map(&:price).sum + unified_seller.unified_transport_price + articles[2].transport_type1_price)
    totals.last.must_have_content(articles[3..4].map(&:price).sum + articles[3..4].map(&:transport_type1_price).sum)

    # checkout

    CartMailer.expects(:seller_email).twice
    CartMailer.expects(:buyer_email)
    find('input.checkout_button').click
    buyer.carts.last.sold?.must_equal true

  end




end


