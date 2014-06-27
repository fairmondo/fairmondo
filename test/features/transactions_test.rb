#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require_relative '../test_helper'
include Warden::Test::Helpers

feature 'Buying Process' do
  let(:user) { FactoryGirl.create :user }
  setup do
    login_as user
  end

  scenario "user buys an article with quantity 1 from a legal_entity" do

    FastbillAPI.stubs(:fastbill_chain)

    TireTest.on
    Article.index.delete
    Article.create_elasticsearch_index
    transaction = FactoryGirl.create :single_transaction, article: FactoryGirl.create(:article, title: 'foobar', seller: FactoryGirl.create(:legal_entity))

    Article.index.refresh
    visit articles_path
    page.must_have_link 'foobar'

    visit edit_business_transaction_path transaction

    transaction.available?.must_equal true
    transaction.article.active?.must_equal true

    page.must_have_content I18n.t 'transaction.edit.heading'

    # Should display article data
    page.must_have_link transaction.article.title
    page.must_have_link transaction.article.seller.nickname
    page.must_have_content I18n.t 'transaction.edit.preliminary_price'

    # Should display purchase options
    page.must_have_content I18n.t 'transaction.edit.choose_purchase_data'
    ## Should display shipping selection
    page.must_have_content I18n.t 'formtastic.labels.business_transaction.selected_transport'
    page.must_have_selector 'select', text: I18n.t('enumerize.business_transaction.selected_transport.pickup')
    ## Should display payment selection
    page.must_have_content I18n.t 'formtastic.labels.business_transaction.selected_payment'
    page.must_have_selector 'select', text: I18n.t('enumerize.business_transaction.selected_payment.cash')
    ## Should display buyer's address
    page.must_have_content I18n.t 'transaction.edit.addresses'

    # Should display info text and button
    page.must_have_content I18n.t 'transaction.edit.next_step_explanation'
    page.must_have_button I18n.t 'common.actions.continue'

    # as this is a single transaction it shouldnt have a quantity field
    page.wont_have_content I18n.t('formtastic.labels.business_transaction.quantity_bought')

    #================== Step 2 =================
    click_button I18n.t 'common.actions.continue'

     # Should have pre-filled hidden fields
    page.must_have_css 'input#business_transaction_quantity_bought[@type=hidden][@value="1"]'
    page.must_have_css 'input#business_transaction_selected_transport[@type=hidden][@value=pickup]'
    page.must_have_css 'input#business_transaction_selected_payment[@type=hidden][@value=cash]'

    # Should display article data
    page.must_have_link transaction.article.title
    page.must_have_link transaction.article.seller.nickname
    page.must_have_content I18n.t 'transaction.edit.preliminary_price'

    # Should display chosen quantity
    page.must_have_content(I18n.t('transaction.edit.quantity_bought')+' 1')

    # Should display chosen payment type
    page.must_have_content I18n.t 'transaction.edit.payment_type'
    page.must_have_content I18n.t 'enumerize.business_transaction.selected_payment.cash'

    # Should display chosen transport type (specs for transport provider further down)
    page.must_have_content I18n.t 'transaction.edit.transport_type'
    page.must_have_content I18n.t 'enumerize.business_transaction.selected_transport.pickup'

    # Should display buyer's address
    page.must_have_content I18n.t 'transaction.edit.addresses'
    page.must_have_content user.fullname
    page.must_have_content user.standard_address_address_line_1
    page.must_have_content user.standard_address_address_line_2
    page.must_have_content user.standard_address_city
    page.must_have_content user.standard_address_zip
    page.must_have_content user.standard_address_country

    # Should have optional message field
    page.must_have_content I18n.t 'transaction.edit.message'

    # Should display buttons
    page.must_have_link I18n.t 'common.actions.back'
    page.must_have_button I18n.t 'transaction.actions.purchase'

    # ------------ legal entity specific fields

    # Should display imprint
    page.must_have_content I18n.t 'transaction.edit.imprint'
    page.must_have_content transaction.article_seller.about

    # Should display terms
    page.must_have_content I18n.t 'transaction.edit.terms'
    page.must_have_content transaction.article_seller.terms

    # Should display declaration of revocation
    page.must_have_content I18n.t 'transaction.edit.cancellation'
    page.must_have_content transaction.article_seller.cancellation

    # Should display a checkbox for the terms
    page.must_have_css 'input#business_transaction_tos_accepted[@type=checkbox]'

    check 'business_transaction_tos_accepted'

    click_button I18n.t 'transaction.actions.purchase'

    current_path.must_equal business_transaction_path transaction

    # ================= Show transaction

    page.must_have_link transaction.article.title
    page.must_have_link transaction.article_seller_nickname
    click_link I18n.t("transaction.actions.print_order.buyer")
    page.must_have_content I18n.t('transaction.notifications.buyer.buyer_text')

    # =============== Assertions
    transaction = transaction.reload
    transaction.available?.must_equal false
    transaction.article.active?.must_equal false
    transaction.sold?.must_equal true
    transaction.article.sold?.must_equal true

    ActionMailer::Base.deliveries.last.to.must_equal [transaction.buyer_email]
    ActionMailer::Base.deliveries[-2].to.must_equal [transaction.article_seller.email]

    #removed from search index?
    Article.index.refresh
    visit articles_path
    page.wont_have_link 'foobar'
    TireTest.off

  end

  scenario "user buys an article with quantity > 1 from a private user" do

    FastbillAPI.stubs(:fastbill_chain)

    TireTest.on
    Article.index.delete
    Article.create_elasticsearch_index
    article =  FactoryGirl.create :article, :with_larger_quantity, seller: FactoryGirl.create(:private_user)
    transaction = article.business_transaction

    # ================= buy one =============
    visit edit_business_transaction_path transaction
    page.must_have_content I18n.t('formtastic.labels.business_transaction.quantity_bought')

    #--------------- step 2
    click_button I18n.t 'common.actions.continue'
    page.wont_have_selector('div.about_terms_cancellation')
    click_button I18n.t 'transaction.actions.purchase'

    visit article_path article
    page.must_have_content I18n.t('formtastic.labels.article.quantity_with_numbers', quantities: (transaction.article_quantity - 1 ))

    # ================ buy remainder ========
    transaction = article.business_transaction.reload
    visit edit_business_transaction_path article.business_transaction

    fill_in 'business_transaction_quantity_bought', with: transaction.quantity_available
    click_button I18n.t 'common.actions.continue'

    click_button I18n.t 'transaction.actions.purchase'
    transaction = article.business_transaction.reload
    ActionMailer::Base.deliveries.last.to.must_equal [user.email]
    ActionMailer::Base.deliveries[-2].to.must_equal [transaction.article_seller.email]

    # ========== assertions
    Article.index.refresh
    transaction.article.sold?.must_equal true
    visit articles_path
    page.wont_have_content Regexp.new transaction.article.title[0..20]
    TireTest.off
  end

  scenario "user prints terms of seller" do
    transaction = FactoryGirl.create :single_transaction, :legal_transaction
    visit edit_business_transaction_path transaction
    click_button I18n.t 'common.actions.continue'
    within '#terms' do
      click_link 'Drucken'
    end
    page.must_have_content transaction.article_seller_terms
  end

  scenario "user prints cancellation of seller" do
    transaction = FactoryGirl.create :single_transaction, :legal_transaction
    visit edit_business_transaction_path transaction
    click_button I18n.t 'common.actions.continue'
    within '#cancellation' do
      click_link 'Drucken'
    end
    page.must_have_content transaction.article_seller_cancellation
  end



  scenario "user does not accept tos" do
    transaction = FactoryGirl.create :single_transaction, :legal_transaction
    visit edit_business_transaction_path transaction

    click_button I18n.t 'common.actions.continue'

    click_button I18n.t 'transaction.actions.purchase'

    page.must_have_selector 'input#business_transaction_tos_accepted[@type=checkbox]' # is still on step 2
    page.must_have_content I18n.t 'errors.messages.accepted'
  end


  scenario "user tries to buy an articles that is bought by someone else" do
    FastbillAPI.stubs(:fastbill_chain)
    business_transaction = FactoryGirl.create :business_transaction
    visit edit_business_transaction_path business_transaction
    click_button I18n.t 'common.actions.continue'

    if business_transaction.article_seller.is_a? LegalEntity
      check 'business_transaction_tos_accepted'
    end

#      mail = Mail::Message.new
#      BusinessTransactionMailer.stubs(:seller_notification).returns(mail)
#      BusinessTransactionMailer.stubs(:buyer_notification).returns(mail)
#      mail.stubs(:deliver)
    business_transaction.update_attribute :state, 'sold'

    click_button I18n.t 'transaction.actions.purchase'
    page.must_have_content 'bereits verkauft.'
  end

  scenario "user selects certain transports and calculates total while buying a single article" do

    # Type 1

    article = FactoryGirl.create(:article, payment_invoice: true, price: 1000, transport_type1: true, transport_type1_price: '10,99', transport_type1_provider: 'DHL')
    transaction = FactoryGirl.create :single_transaction, article: article

    visit edit_business_transaction_path transaction
    select I18n.t 'enumerize.business_transaction.selected_transport.type1', from: 'business_transaction_selected_transport'
    select I18n.t 'enumerize.business_transaction.selected_payment.invoice', from: 'business_transaction_selected_payment'
    click_button I18n.t 'common.actions.continue'

    page.wont_have_content I18n.t 'transaction.edit.payment_cash_on_delivery_price' # could be put in a separate test
    page.must_have_content '1.010,99'
    page.must_have_content I18n.t('transaction.edit.transport_provider')
    page.must_have_content 'DHL'

    # Type 2

    article = FactoryGirl.create(:article, payment_invoice: true, price: 1000, transport_type2: true, transport_type2_price: '5,99', transport_type2_provider: 'DHL')
    transaction = FactoryGirl.create :single_transaction, article: article

    visit edit_business_transaction_path transaction
    select I18n.t 'enumerize.business_transaction.selected_transport.type2', from: 'business_transaction_selected_transport'
    select I18n.t 'enumerize.business_transaction.selected_payment.invoice', from: 'business_transaction_selected_payment'
    click_button I18n.t 'common.actions.continue'

    page.must_have_content '1.005,99'
    page.must_have_content I18n.t('transaction.edit.transport_provider')
    page.must_have_content 'DHL'

    # Pickup
    article = FactoryGirl.create(:article, price: 999)
    transaction = FactoryGirl.create :single_transaction, article: article
    visit edit_business_transaction_path transaction
    select I18n.t 'enumerize.business_transaction.selected_transport.pickup', from: 'business_transaction_selected_transport'
    click_button I18n.t 'common.actions.continue'

    page.wont_have_content I18n.t('transaction.edit.transport_provider')
    page.must_have_content '999'

    # cash on devlivery
    article = FactoryGirl.create(:article, payment_cash_on_delivery: true, payment_cash_on_delivery_price: '7,77', price: 1000, transport_type1: true, transport_type1_price: '10,99', transport_type1_provider: 'DHL')
    transaction = FactoryGirl.create :business_transaction, article: article

    visit edit_business_transaction_path transaction
    select I18n.t 'enumerize.business_transaction.selected_transport.type1', from: 'business_transaction_selected_transport'
    select I18n.t 'enumerize.business_transaction.selected_payment.cash_on_delivery', from: 'business_transaction_selected_payment'
    click_button I18n.t 'common.actions.continue'

    page.must_have_content I18n.t('transaction.edit.payment_cash_on_delivery_price')
    page.must_have_content '7,77'
    page.must_have_content '1.018,76'

  end

  scenario "user calculates total price for quantity > 0 and a basic price" do
    article = FactoryGirl.create(:article, :with_larger_quantity, price: 222, basic_price: '1111,11')
    transaction = FactoryGirl.create :multiple_transaction, article: article

    visit edit_business_transaction_path transaction
    fill_in 'business_transaction_quantity_bought', with: 2
    click_button I18n.t 'common.actions.continue'

    page.must_have_content '444'
    page.must_have_content I18n.t 'transaction.edit.basic_price'
    page.must_have_content '1.111,11'

  end


  scenario "user enters invalid data while buying an Article" do
    skip('New feature test has to be written for address')
  end

  scenario "user enters a quantity that is larger than available" do
    transaction = FactoryGirl.create(:multiple_transaction)
    visit edit_business_transaction_path transaction
    fill_in 'business_transaction_quantity_bought', with: '9999999'
    click_button I18n.t 'common.actions.continue'

    within '#business_transaction_quantity_bought_input' do
      page.must_have_content I18n.t('transaction.errors.too_many_bought', available: transaction.quantity_available)
    end

  end

  scenario "user visits other user's transaction" do
    transaction = FactoryGirl.create :single_transaction, :sold
    login_as FactoryGirl.create :user
    -> {  visit business_transaction_path transaction }.must_raise(Pundit::NotAuthorizedError)
  end

  scenario "user visits a transaction that is not already sold" do
    login_as user
    transaction = FactoryGirl.create :single_transaction
    visit business_transaction_path transaction
    current_path.must_equal edit_business_transaction_path transaction
  end

  scenario "user visits parent transaction for some reason" do
    transaction = FactoryGirl.create :partial_transaction
    login_as transaction.buyer
    visit business_transaction_path transaction.parent
    current_path.must_equal business_transaction_path(transaction)
  end

end
