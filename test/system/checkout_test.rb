#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class CheckoutTest < ApplicationSystemTestCase
  test 'Buying a cart with one item (default) from private user' do
    seller = create :private_user
    article = create(:article, title: 'foobar', seller: seller)
    sign_in create(:user)
    visit article_path(article)

    # add things to cart ( hard to generate this via factory because it is
    # kinda hard to set a signed cookie in capybara )

    click_button I18n.t('common.actions.to_cart')
    click_link(I18n.t('header.cart.title', count: 1), match: :first)

    # Step 1

    click_link I18n.t('cart.actions.checkout')
    line_item_group_id = article.line_items.first.line_item_group_id
    page.check("cart_checkout_form_line_item_groups_#{line_item_group_id}_tos_accepted")

    # Step 2

    click_button I18n.t('common.actions.continue')
    page.find('.Payment-value--total').must_have_content(
      (article.price + article.transport_type1_price).to_s
    )

    # checkout

    FastbillAPI.any_instance.expects(:fastbill_chain).never

    find('input.checkout_button').click
    expect_cart_emails
    # No donation display, because private seller:
    page.wont_have_content('Einkäufen hast Du Fairmondo bisher eine Spende')
    assert Cart.last.sold?
    visit line_item_group_path(LineItemGroup.last)
    page.find('.Payment-value--total').must_have_content(
      (article.price + article.transport_type1_price).to_s
    )
    visit line_item_group_path(LineItemGroup.last, tab: 'transports')
    page.must_have_selector('.transport_table')
    visit line_item_group_path(LineItemGroup.last, tab: 'rating')
  end

  test 'User selects cash as unified_payment and does not select pickup and changes it to pickup in the end' do
    seller = create :legal_entity, :paypal_data
    articles = [create(:article, :with_all_payments, :with_all_transports, seller: seller, unified_transport: false)]
    articles << create(:article, :with_all_payments, :with_all_transports, seller: seller, unified_transport: false)
    sign_in create(:user)

    articles.each do |article|
      visit article_path(article)
      click_button I18n.t('common.actions.to_cart')
    end

    click_link(I18n.t('header.cart.title', count: 2), match: :first)

    # Step 1 errors

    click_link I18n.t('cart.actions.checkout')
    first_line_item = articles.first.line_items.first
    page.check("cart_checkout_form_line_item_groups_#{first_line_item.line_item_group_id}_tos_accepted")

    page.find("select#cart_checkout_form_line_item_groups_#{first_line_item.line_item_group_id}_unified_payment_method")
        .find("option[value='cash']")
        .select_option

    click_button I18n.t('common.actions.continue')

    # Step 1 correct errors

    assert page.has_content? I18n.t 'transaction.errors.combination_invalid',
                                  selected_payment: I18n.t('enumerize.business_transaction.selected_payment.cash')

    page.find("select#cart_checkout_form_line_items_#{first_line_item.id}_business_transaction_selected_transport")
        .find("option[value='pickup']")
        .select_option

    second_line_item = articles.second.line_items.first
    page.find("select#cart_checkout_form_line_items_#{second_line_item.id}_business_transaction_selected_transport")
        .find("option[value='pickup']")
        .select_option

    click_button I18n.t('common.actions.continue')

    # Step 2

    page.find('.Payment-value--total').must_have_content(articles.map(&:price).sum.to_s)

    # checkout

    find('input.checkout_button').click
    expect_cart_emails

    assert Cart.last.sold?
  end

  test 'Buying a cart with one item and free transport and change the
            shipping address' do
    seller = create :legal_entity, :with_free_transport_at_5

    article = create(:article, title: 'foobar', price_cents: 600, seller: seller)
    buyer = create(:user)
    transport_address = create(:address, user: buyer)
    buyer.addresses << transport_address
    sign_in buyer
    visit article_path(article)

    # add things to cart ( hard to generate this via factory because it is kinda hard to set a signed cookie in capybara )

    click_button I18n.t('common.actions.to_cart')
    click_link(I18n.t('header.cart.title', count: 1), match: :first)

    # Step 1

    click_link I18n.t('cart.actions.checkout')
    line_item_group_id = article.line_items.first.line_item_group_id
    page.check("cart_checkout_form_line_item_groups_#{line_item_group_id}_tos_accepted")
    page.choose("cart_checkout_form_transport_address_id_#{transport_address.id}")
    # Step 2

    click_button I18n.t('common.actions.continue')
    page.find('.Payment-value--total').must_have_content(article.price.to_s)

    # checkout

    find('input.checkout_button').click
    expect_cart_emails
    assert page.has_content?(
      'Vielen Dank für Deinen Einkauf')
    assert Cart.last.sold?
    Cart.last.line_item_groups.first.transport_address.must_equal transport_address
  end

  test 'Buying a cart with items from different users' do
    unified_seller = create :legal_entity, :with_unified_transport_information, :paypal_data
    articles = [create(:article, :with_all_payments, :with_all_transports, title: 'unified1', seller: unified_seller),
                create(:article, :with_all_payments, :with_all_transports, title: 'unified2', seller: unified_seller),
                create(:article, :with_all_payments, title: 'single_transport1', seller: unified_seller, unified_transport: false)]

    single_seller = create :legal_entity, :paypal_data
    articles << create(:article, :with_all_payments, :with_all_transports, title: 'single_transport2', seller: single_seller, unified_transport: false)
    articles << create(:article, :with_all_payments, :with_all_transports, title: 'single_transport3', seller: single_seller, unified_transport: false)

    buyer = create(:user)
    sign_in buyer

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
      notice.must_have_content(I18n.t('cart.texts.unified_transport_notice', price: '3,00 €'))
    end
    transport_notices[2].must_have_content(I18n.t('cart.texts.unified_transport_impossible'))

    first_line_item_group_id = articles.first.line_items.first.line_item_group_id
    second_line_item_group_id = articles.last.line_items.first.line_item_group_id
    page.check("cart_checkout_form_line_item_groups_#{first_line_item_group_id}_tos_accepted")
    page.check("cart_checkout_form_line_item_groups_#{second_line_item_group_id}_tos_accepted")

    [articles.fourth, articles.fifth].each do |article|
      line_item_id = article.line_items.first.id
      page.find("select#cart_checkout_form_line_items_#{ line_item_id }_business_transaction_selected_transport")
          .find('option[value=type1]')
          .select_option
    end

    # Step 2

    click_button I18n.t('common.actions.continue')
    totals = page.all('.Payment-value--total')

    totals_expected =
      [articles[0..2].map(&:price).sum + unified_seller.unified_transport_price + articles[2].transport_type1_price,
       articles[3..4].map(&:price).sum + articles[3..4].map(&:transport_type1_price).sum].map { |t| t.format(format: '%n %u') }.sort

    totals.map(&:text).sort.each_with_index do |total, i|
      assert_equal total, totals_expected[i]
    end

    # checkout

    find('input.checkout_button').click
    expect_cart_emails(seller: 2)
    assert buyer.carts.last.sold?
  end

  test 'Trying to buy a cart with unified transport and cash on delivery and dont check agb. Afterwards try to resume with single transports' do
    seller = create :legal_entity, :with_unified_transport_information, :paypal_data
    articles = [create(:article, :with_all_payments, :with_all_transports, title: 'foobar', seller: seller)]
    articles << create(:article, :with_all_payments, :with_all_transports, title: 'foobar2', seller: seller)

    sign_in create(:user)
    articles.each do |article|
      visit article_path(article)
      click_button I18n.t('common.actions.to_cart')
    end

    # add things to cart ( hard to generate this via factory because it is kinda hard to set a signed cookie in capybara )

    click_link(I18n.t('header.cart.title', count: 2), match: :first)

    # Step 1

    click_link I18n.t('cart.actions.checkout')

    first_line_item_group_id = articles.first.line_items.first.line_item_group_id
    page.find("select#cart_checkout_form_line_item_groups_#{first_line_item_group_id}_unified_payment_method")
        .find("option[value='cash_on_delivery']")
        .select_option
    click_button I18n.t('common.actions.continue')

    # Step 1 errored

    assert page.has_content? I18n.t('transaction.errors.cash_on_delivery_with_unified_transport')
    assert page.has_content? I18n.t('active_record.error_messages.accepted')

    page.check("cart_checkout_form_line_item_groups_#{first_line_item_group_id}_tos_accepted")
    page.find("select#cart_checkout_form_line_item_groups_#{first_line_item_group_id}_unified_payment_method")
        .find("option[value='invoice']")
        .select_option

    click_button I18n.t('common.actions.continue')
    # checkout

    find('input.checkout_button').click
    expect_cart_emails
    assert Cart.last.sold?
  end

  test 'Buying a cart with one item that is already deactivated by the time he buys it' do
    article = create(:article, title: 'foobar')
    sign_in create(:user)
    visit article_path(article)

    # add things to cart ( hard to generate this via factory because it is kinda hard to set a signed cookie in capybara )

    click_button I18n.t('common.actions.to_cart')
    click_link(I18n.t('header.cart.title', count: 1), match: :first)

    # Step 1

    click_link I18n.t('cart.actions.checkout')
    line_item_group_id = article.line_items.first.line_item_group_id
    page.check("cart_checkout_form_line_item_groups_#{line_item_group_id}_tos_accepted")

    # Step 2

    click_button I18n.t('common.actions.continue')

    # checkout
    article.deactivate

    find('input.checkout_button').click
    refute Cart.last.sold?
    assert page.has_content? I18n.t('cart.notices.checkout_failed')
  end

  test 'Buying a cart with one item that is already bought by the time he buys it' do
    article = create(:article, title: 'foobar')
    sign_in create(:user)
    visit article_path(article)

    # add things to cart ( hard to generate this via factory because it is kinda hard to set a signed cookie in capybara )

    click_button I18n.t('common.actions.to_cart')
    click_link(I18n.t('header.cart.title', count: 1), match: :first)

    # Step 1

    click_link I18n.t('cart.actions.checkout')
    line_item_group_id = article.line_items.first.line_item_group_id
    page.check("cart_checkout_form_line_item_groups_#{line_item_group_id}_tos_accepted")

    # Step 2

    click_button I18n.t('common.actions.continue')

    # checkout
    article.update_attribute(:quantity_available, 0)

    find('input.checkout_button').click
    refute Cart.last.sold?
    assert page.has_content? I18n.t('cart.notices.checkout_failed')
  end

  test 'Buying a cart with an invalid line item' do
    article = create(:article, title: 'foobar')
    sign_in create(:user)
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    article.update_attribute(:quantity_available, 0)
    visit edit_cart_path(Cart.last)
    assert page.has_content? I18n.t('activerecord.errors.models.line_item.attributes.requested_quantity.less_than_or_equal_to', count: 0)
  end

  test 'Buying a cart with an incomplete user and adding address during checkout' do
    article = create(:article, title: 'foobar')
    sign_in create(:incomplete_user)
    visit article_path(article)

    # add things to cart
    click_button I18n.t('common.actions.to_cart')
    click_link(I18n.t('header.cart.title', count: 1), match: :first)
    click_link I18n.t('cart.actions.checkout')

    # Step 1
    line_item_group_id = article.line_items.first.line_item_group_id
    page.check("cart_checkout_form_line_item_groups_#{line_item_group_id}_tos_accepted")

    # only check agb to see if we get proper errors
    click_button I18n.t('common.actions.continue')

    find('#cart_checkout_form_address_first_name_input').must_have_content I18n.t('active_record.error_messages.blank')
    find('#cart_checkout_form_address_last_name_input').must_have_content I18n.t('active_record.error_messages.blank')
    # its ok then ommit the rest of the fields since this is covered by model test probably

    page.fill_in 'cart_checkout_form_address_first_name', with: 'first_name_is_here'
    page.fill_in 'cart_checkout_form_address_last_name', with: 'last_name'
    page.fill_in 'cart_checkout_form_address_address_line_1', with: 'street 1'
    page.fill_in 'cart_checkout_form_address_zip', with: '11111'
    page.fill_in 'cart_checkout_form_address_city', with: 'city'
    page.find('select#cart_checkout_form_address_country').find('option:last').select_option

    # Step 2

    click_button I18n.t('common.actions.continue')
    find('input.checkout_button').click
    expect_cart_emails
    assert Cart.last.sold?
    assert_equal Cart.last.line_item_groups.first.transport_address.first_name, 'first_name_is_here'
    assert_equal Cart.last.line_item_groups.first.payment_address.first_name, 'first_name_is_here'
  end

  test 'send open cart via emailcart page should have all the right contents' do
    article = create(:article, title: 'foobar')
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page_must_include_notice_for(article)
    click_link(I18n.t('header.cart.title', count: 1), match: :first)
    assert page.has_content? 'foobar'
    assert page.has_content? 'Die Artikel als Merkliste per E-Mail versenden'

    click_link('Die Artikel als Merkliste per E-Mail versenden', match: :first)
    assert page.has_content? 'Als Merkliste per E-Mail versenden'
    page.html.must_include 'Jetzt versenden'

    page.fill_in 'email_email', with: 'test@test.com'
    click_button 'Jetzt versenden'
  end

  def expect_cart_emails(buyer: 1, seller: 1)
    seller_mails = ActionMailer::Base.deliveries.select { |mail| mail.subject.include?('Artikel auf Fairmondo verkauft') }
    buyer_mails = ActionMailer::Base.deliveries.select { |mail| mail.subject.include?('Dein Einkauf') }
    assert_equal seller_mails.size, seller
    assert_equal buyer_mails.size, buyer
  end

  def page_must_include_notice_for(article)
    cart = article.line_items.first.cart
    _(page.html).must_include I18n.t('line_item.notices.success_create', href: "/carts/#{cart.id}").html_safe
  end
end
