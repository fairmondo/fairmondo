require_relative '../test_helper'

include Warden::Test::Helpers

def expect_cart_emails arg = :once
  Mail::Message.any_instance.stubs(:deliver)
  CartMailer.expects(:seller_email).returns(Mail::Message.new).send arg
  CartMailer.expects(:buyer_email).returns(Mail::Message.new)
end

feature 'Empty cart' do
  it 'header should show link to empty cart' do
    visit root_path
    page.html.must_include I18n.t('header.cart.title', count: 0)
    click_link(I18n.t('header.cart.title', count: 0), match: :first)
    page.must_have_content 'Dein Warenkorb ist leer.'
  end
end

feature 'Adding an Article to the cart' do
  scenario 'anonymous user adds article to his cart' do
    article = FactoryGirl.create(:article, title: 'foobar')
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page.html.must_include I18n.t('line_item.notices.success_create', href: '/carts/1').html_safe
    click_link(I18n.t('header.cart.title', count: 1), match: :first)
    page.must_have_content 'foobar'
  end

  scenario 'logged-in user adds article to his cart' do
    article = FactoryGirl.create(:article, title: 'foobar')
    login_as FactoryGirl.create(:user)
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page.html.must_include I18n.t('line_item.notices.success_create', href: '/carts/1').html_safe
    click_link(I18n.t('header.cart.title', count: 1), match: :first)
    page.must_have_content 'foobar'
  end

  scenario 'logged-in user adds article to his cart and is logged out by the system' do
    article = FactoryGirl.create(:article, title: 'foobar')
    user = FactoryGirl.create(:user)
    login_as user
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page.html.must_include I18n.t('line_item.notices.success_create', href: '/carts/1').html_safe
    logout(:user) # simulate logout
    visit root_path
    page.wont_have_content I18n.t('header.cart.title', count: 1)
    login_as FactoryGirl.create(:user)
    page.wont_have_content I18n.t('header.cart.title', count: 1)
    Cart.last.user.must_equal user
  end

  scenario 'logged-in user adds article to his cart and logs out' do
    article = FactoryGirl.create(:article, title: 'foobar')
    user = FactoryGirl.create(:user)
    login_as user
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page.html.must_include I18n.t('line_item.notices.success_create', href: '/carts/1').html_safe

    within '.l-header-nav' do
      click_link I18n.t('common.actions.logout')
    end

    page.wont_have_content I18n.t('header.cart.title', count: 1)
    login_as FactoryGirl.create(:user)
    page.wont_have_content I18n.t('header.cart.title', count: 1)
    Cart.last.user.must_equal user
  end

  scenario 'logged-in user adds article twice to his cart' do
    article = FactoryGirl.create(:article)
    login_as FactoryGirl.create(:user)
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page.html.must_include I18n.t('line_item.notices.success_create', href: '/carts/1').html_safe
    page.wont_have_content I18n.t('common.actions.to_cart')
    Cart.last.line_items.count.must_equal 1
    Cart.last.line_items.first.requested_quantity.must_equal 1
  end

  scenario 'logged-in user adds article that is available in quantity >= 2 twice to to his cart' do
    article = FactoryGirl.create(:article, :with_larger_quantity)
    login_as FactoryGirl.create(:user)
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page.html.must_include I18n.t('line_item.notices.success_create', href: '/carts/1').html_safe
    click_button I18n.t('common.actions.to_cart')
    page.html.must_include I18n.t('line_item.notices.success_create', href: '/carts/1').html_safe
    Cart.last.line_items.count.must_equal 1
    Cart.last.line_items.first.requested_quantity.must_equal 2
  end

  scenario 'logged-in user adds article that is available in quantity >= 2 twice to to his cart and requests more than available' do
    article = FactoryGirl.create(:article, :with_larger_quantity)
    login_as FactoryGirl.create(:user)
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page.html.must_include I18n.t('line_item.notices.success_create', href: '/carts/1').html_safe
    fill_in 'line_item_requested_quantity', with: article.quantity
    click_button I18n.t('common.actions.to_cart')
    page.html.must_include I18n.t('line_item.notices.error_quantity')
    Cart.last.line_items.count.must_equal 1
    Cart.last.line_items.first.requested_quantity.must_equal 1
  end
end

feature 'updating quantity of the cart' do
  scenario 'change quantity to 10 from 1' do
    article = FactoryGirl.create(:article, quantity: 10)
    login_as FactoryGirl.create(:user)
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    page.html.must_include I18n.t('line_item.notices.success_create', href: '/carts/1').html_safe
    click_link(I18n.t('header.cart.title', count: 1), match: :first)

    # within('.change_quantity') do
    #  fill_in 'line_item_requested_quantity', with: 10
    #  find('button.Button').click
    # end
    # Cart.last.line_items.first.requested_quantity.must_equal 10
  end
end

feature 'Checkout' do
  scenario 'Buying a cart with one item (default) from private user' do
    seller = FactoryGirl.create :private_user
    article = FactoryGirl.create(:article, title: 'foobar', seller: seller)
    login_as FactoryGirl.create(:user)
    visit article_path(article)

    # add things to cart ( hard to generate this via factory because it is
    # kinda hard to set a signed cookie in capybara )

    click_button I18n.t('common.actions.to_cart')
    click_link(I18n.t('header.cart.title', count: 1), match: :first)

    # Step 1

    click_link I18n.t('cart.actions.checkout')
    page.check('cart_checkout_form_line_item_groups_1_tos_accepted')

    # Step 2

    click_button I18n.t('common.actions.continue')
    page.find('.Payment-value--total').must_have_content(
      article.price + article.transport_type1_price)

    # checkout

    expect_cart_emails
    FastbillAPI.any_instance.expects(:fastbill_chain).never

    find('input.checkout_button').click
    # No donation display, because private seller:
    page.wont_have_content('Einkäufen hast Du Fairmondo bisher eine Spende')
    Cart.last.sold?.must_equal true
    visit line_item_group_path(LineItemGroup.last)
    page.find('.Payment-value--total').must_have_content(
      article.price + article.transport_type1_price)
    visit line_item_group_path(LineItemGroup.last, tab: 'transports')
    page.must_have_selector('.transport_table')
    visit line_item_group_path(LineItemGroup.last, tab: 'rating')
  end

  scenario 'User selects cash as unified_payment and does not select pickup and changes it to pickup in the end' do
    seller = FactoryGirl.create :legal_entity, :paypal_data
    articles = [FactoryGirl.create(:article, :with_all_payments, :with_all_transports, seller: seller, unified_transport: false)]
    articles << FactoryGirl.create(:article, :with_all_payments, :with_all_transports, seller: seller, unified_transport: false)
    login_as FactoryGirl.create(:user)

    articles.each do |article|
      visit article_path(article)
      click_button I18n.t('common.actions.to_cart')
    end

    click_link(I18n.t('header.cart.title', count: 2), match: :first)

    # Step 1 errors

    click_link I18n.t('cart.actions.checkout')
    page.check('cart_checkout_form_line_item_groups_1_tos_accepted')
    page.find('select#cart_checkout_form_line_item_groups_1_unified_payment_method').find("option[value='cash']").select_option
    page.find('select#cart_checkout_form_line_item_groups_1_unified_payment_method').find("option[value='cash']").select_option

    click_button I18n.t('common.actions.continue')

    # Step 1 correct errors

    page.must_have_content I18n.t 'transaction.errors.combination_invalid',
                                  selected_payment: I18n.t('enumerize.business_transaction.selected_payment.cash')

    page.find('select#cart_checkout_form_line_items_1_business_transaction_selected_transport').find("option[value='pickup']").select_option
    page.find('select#cart_checkout_form_line_items_2_business_transaction_selected_transport').find("option[value='pickup']").select_option

    click_button I18n.t('common.actions.continue')

    # Step 2

    page.find('.Payment-value--total').must_have_content(articles.map(&:price).sum)

    # checkout

    expect_cart_emails
    find('input.checkout_button').click

    Cart.last.sold?.must_equal true
  end

  scenario 'Buying a cart with one item and free transport and change the
            shipping address' do
    seller = FactoryGirl.create :legal_entity, :with_free_transport_at_5

    article = FactoryGirl.create(:article, title: 'foobar',
                                           price_cents: 600,
                                           seller: seller)
    buyer = FactoryGirl.create(:user)
    transport_address = FactoryGirl.create(:address, user: buyer)
    buyer.addresses << transport_address
    login_as buyer
    visit article_path(article)

    # add things to cart ( hard to generate this via factory because it is kinda hard to set a signed cookie in capybara )

    click_button I18n.t('common.actions.to_cart')
    click_link(I18n.t('header.cart.title', count: 1), match: :first)

    # Step 1

    click_link I18n.t('cart.actions.checkout')
    page.check('cart_checkout_form_line_item_groups_1_tos_accepted')
    page.choose("cart_checkout_form_transport_address_id_#{transport_address.id}")
    # Step 2

    click_button I18n.t('common.actions.continue')
    page.find('.Payment-value--total').must_have_content(article.price)

    # checkout

    expect_cart_emails
    find('input.checkout_button').click
    page.must_have_content(
      'Mit Deinen Einkäufen hast Du Fairmondo bisher eine Spende von 0,06 Euro')
    Cart.last.sold?.must_equal true
    Cart.last.line_item_groups.first.transport_address.must_equal transport_address
  end

  scenario 'Buying a cart with items from different users' do
    unified_seller = FactoryGirl.create :legal_entity, :with_unified_transport_information, :paypal_data
    articles = [FactoryGirl.create(:article, :with_all_payments, :with_all_transports, title: 'unified1', seller: unified_seller),
                FactoryGirl.create(:article, :with_all_payments, :with_all_transports, title: 'unified2', seller: unified_seller),
                FactoryGirl.create(:article, :with_all_payments, title: 'single_transport1', seller: unified_seller, unified_transport: false)]

    single_seller =  FactoryGirl.create :legal_entity, :paypal_data
    articles << FactoryGirl.create(:article, :with_all_payments, :with_all_transports, title: 'single_transport2', seller: single_seller, unified_transport: false)
    articles << FactoryGirl.create(:article, :with_all_payments, :with_all_transports, title: 'single_transport3', seller: single_seller, unified_transport: false)

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
      notice.must_have_content(I18n.t('cart.texts.unified_transport_notice', price: '3,00 €'))
    end
    transport_notices[2].must_have_content(I18n.t('cart.texts.unified_transport_impossible'))
    page.check('cart_checkout_form_line_item_groups_1_tos_accepted')
    page.check('cart_checkout_form_line_item_groups_2_tos_accepted')

    (4..5).each do |num|
      page.find("select#cart_checkout_form_line_items_#{ num }_business_transaction_selected_transport").find('option[value=type1]').select_option
    end

    # Step 2

    click_button I18n.t('common.actions.continue')
    totals = page.all('.Payment-value--total')

    totals_expected =
      [articles[0..2].map(&:price).sum + unified_seller.unified_transport_price + articles[2].transport_type1_price,
       articles[3..4].map(&:price).sum + articles[3..4].map(&:transport_type1_price).sum].map { |t| t.format_with_settings(symbol_position: :after) }.sort

    totals.map(&:text).sort.each_with_index do |total, i|
      total.must_equal totals_expected[i]
    end

    # checkout

    expect_cart_emails :twice
    find('input.checkout_button').click
    buyer.carts.last.sold?.must_equal true
  end

  scenario 'Trying to buy a cart with unified transport and cash on delivery and dont check agb. Afterwards try to resume with single transports' do
    seller = FactoryGirl.create :legal_entity, :with_unified_transport_information, :paypal_data
    articles = [FactoryGirl.create(:article, :with_all_payments, :with_all_transports, title: 'foobar', seller: seller)]
    articles << FactoryGirl.create(:article, :with_all_payments, :with_all_transports, title: 'foobar2', seller: seller)

    login_as FactoryGirl.create(:user)
    articles.each do |article|
      visit article_path(article)
      click_button I18n.t('common.actions.to_cart')
    end

    # add things to cart ( hard to generate this via factory because it is kinda hard to set a signed cookie in capybara )

    click_link(I18n.t('header.cart.title', count: 2), match: :first)

    # Step 1

    click_link I18n.t('cart.actions.checkout')

    page.find('select#cart_checkout_form_line_item_groups_1_unified_payment_method').find("option[value='cash_on_delivery']").select_option
    click_button I18n.t('common.actions.continue')

    # Step 1 errored

    page.must_have_content I18n.t('transaction.errors.cash_on_delivery_with_unified_transport')
    page.must_have_content I18n.t('active_record.error_messages.accepted')

    page.check('cart_checkout_form_line_item_groups_1_tos_accepted')
    page.find('select#cart_checkout_form_line_item_groups_1_unified_payment_method').find("option[value='invoice']").select_option

    click_button I18n.t('common.actions.continue')
    # checkout

    expect_cart_emails
    find('input.checkout_button').click
    Cart.last.sold?.must_equal true
  end

  scenario 'Buying a cart with one item that is already deactivated by the time he buys it' do
    article = FactoryGirl.create(:article, title: 'foobar')
    login_as FactoryGirl.create(:user)
    visit article_path(article)

    # add things to cart ( hard to generate this via factory because it is kinda hard to set a signed cookie in capybara )

    click_button I18n.t('common.actions.to_cart')
    click_link(I18n.t('header.cart.title', count: 1), match: :first)

    # Step 1

    click_link I18n.t('cart.actions.checkout')
    page.check('cart_checkout_form_line_item_groups_1_tos_accepted')

    # Step 2

    click_button I18n.t('common.actions.continue')

    # checkout
    article.deactivate

    find('input.checkout_button').click
    Cart.last.sold?.must_equal false
    page.must_have_content I18n.t('cart.notices.checkout_failed')
  end

  scenario 'Buying a cart with one item that is already bought by the time he buys it' do
    article = FactoryGirl.create(:article, title: 'foobar')
    login_as FactoryGirl.create(:user)
    visit article_path(article)

    # add things to cart ( hard to generate this via factory because it is kinda hard to set a signed cookie in capybara )

    click_button I18n.t('common.actions.to_cart')
    click_link(I18n.t('header.cart.title', count: 1), match: :first)

    # Step 1

    click_link I18n.t('cart.actions.checkout')
    page.check('cart_checkout_form_line_item_groups_1_tos_accepted')

    # Step 2

    click_button I18n.t('common.actions.continue')

    # checkout
    article.update_attribute(:quantity_available, 0)

    find('input.checkout_button').click
    Cart.last.sold?.must_equal false
    page.must_have_content I18n.t('cart.notices.checkout_failed')
  end

  scenario 'Buying a cart with an invalid line item' do
    article = FactoryGirl.create(:article, title: 'foobar')
    login_as FactoryGirl.create(:user)
    visit article_path(article)
    click_button I18n.t('common.actions.to_cart')
    article.update_attribute(:quantity_available, 0)
    visit edit_cart_path(Cart.last)
    page.must_have_content I18n.t('activerecord.errors.models.line_item.attributes.requested_quantity.less_than_or_equal_to', count: 0)
  end

  scenario 'Buying a cart with an incomplete user and adding address during checkout' do
    article = FactoryGirl.create(:article, title: 'foobar')
    login_as FactoryGirl.create(:incomplete_user)
    visit article_path(article)

    # add things to cart
    click_button I18n.t('common.actions.to_cart')
    click_link(I18n.t('header.cart.title', count: 1), match: :first)
    click_link I18n.t('cart.actions.checkout')

    # Step 1
    page.check('cart_checkout_form_line_item_groups_1_tos_accepted')

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
    expect_cart_emails
    find('input.checkout_button').click
    Cart.last.sold?.must_equal true
    Cart.last.line_item_groups.first.transport_address.first_name.must_equal 'first_name_is_here'
    Cart.last.line_item_groups.first.payment_address.first_name.must_equal 'first_name_is_here'
  end

  feature 'send open cart via email' do
    it 'cart page should have all the right contents' do
      article = FactoryGirl.create(:article, title: 'foobar')
      visit article_path(article)
      click_button I18n.t('common.actions.to_cart')
      page.html.must_include I18n.t('line_item.notices.success_create', href: '/carts/1').html_safe
      click_link(I18n.t('header.cart.title', count: 1), match: :first)
      page.must_have_content 'foobar'
      page.must_have_content 'Die Artikel als Merkliste per E-Mail versenden'

      click_link('Die Artikel als Merkliste per E-Mail versenden', match: :first)
      page.must_have_content 'Als Merkliste per E-Mail versenden'
      page.html.must_include 'Jetzt versenden'

      page.fill_in 'email_email', with: 'test@test.com'
      click_button 'Jetzt versenden'
    end
  end
end
