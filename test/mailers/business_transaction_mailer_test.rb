require "test_helper"
require "email_spec"

describe BusinessTransactionMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  it "should notify the seller properly" do
    business_transaction  = FactoryGirl.create :business_transaction_with_buyer
    buyer                 = business_transaction.buyer
    business_transaction.shipping_address = buyer.standard_address
    business_transaction.billing_address  = buyer.standard_address

    mail = BusinessTransactionMailer.seller_notification(business_transaction)

    mail.must deliver_to(business_transaction.seller.email)
    mail.must have_subject("[Fairnopoly] " + I18n.t('transaction.notifications.seller.seller_subject') + " (#{business_transaction.article_title})")
    mail.must have_body_text(I18n.t('transaction.notifications.seller.intro'))
    mail.must have_body_text(I18n.t('transaction.notifications.greeting') + business_transaction.seller.standard_address_first_name + ',')
    mail.must have_body_text(I18n.t('transaction.notifications.seller.order_infos'))
    mail.must have_body_text(I18n.t('transaction.notifications.seller.pickup_info'))
    mail.must have_body_text(I18n.t('transaction.notifications.seller.buyer_email'))
    mail.must have_body_text(business_transaction.buyer.email)
  end

  it "should notify the seller properly with friendly_percent" do
    business_transaction_with_fp = FactoryGirl.create :business_transaction_with_friendly_percent_and_buyer
    buyer                 = business_transaction_with_fp.buyer
    business_transaction_with_fp.shipping_address = buyer.standard_address
    business_transaction_with_fp.billing_address  = buyer.standard_address

    mail = BusinessTransactionMailer.seller_notification( business_transaction_with_fp )

    mail.must deliver_to( business_transaction_with_fp.seller.email )
    mail.must have_subject("[Fairnopoly] " + I18n.t('transaction.notifications.seller.seller_subject') + " (#{business_transaction_with_fp.article_title})" +
      I18n.t('transaction.notifications.seller.with_donation_to') + "#{business_transaction_with_fp.article.friendly_percent_organisation_nickname}")

  end

  it "should notify the seller properly with friendly_percent and no bank data" do
    business_transaction_with_fp = FactoryGirl.create :business_transaction_with_friendly_percent_missing_bank_data_and_buyer
    buyer                 = business_transaction_with_fp.buyer
    business_transaction_with_fp.shipping_address = buyer.standard_address
    business_transaction_with_fp.billing_address  = buyer.standard_address

    mail = BusinessTransactionMailer.seller_notification( business_transaction_with_fp )
    mail.must have_body_text(I18n.t('transaction.notifications.seller.no_bank_acount'))
  end

  it "should notify the buyer" do
    business_transaction =  FactoryGirl.create :business_transaction_with_buyer
    buyer                 = business_transaction.buyer
    business_transaction.shipping_address = buyer.standard_address
    business_transaction.billing_address  = buyer.standard_address

    mail = BusinessTransactionMailer.buyer_notification( business_transaction )

    mail.must deliver_to( business_transaction.buyer_email )
    mail.must have_subject("[Fairnopoly] " + I18n.t('transaction.notifications.buyer.buyer_subject') + " (#{business_transaction.article_title})")
    mail.must have_body_text(I18n.t('transaction.notifications.buyer.intro'))
    mail.must have_body_text(I18n.t('transaction.notifications.greeting') + business_transaction.buyer.standard_address_first_name + ',')
    mail.must have_body_text(I18n.t('transaction.notifications.buyer.security_warning'))
    mail.must have_body_text(I18n.t('transaction.notifications.buyer.order_infos'))
    mail.must have_body_text(business_transaction.seller.email )
    mail.must have_body_text( business_transaction.article_title )
    mail.must have_body_text( "/articles/#{business_transaction.article.slug}" )
    mail.must have_body_text( "business_transactions/#{business_transaction.id}" )
  end

  it "should notify the buyer when pickup and cash are selected" do
    business_transaction =  FactoryGirl.create :business_transaction_with_buyer, selected_transport: "pickup", selected_payment: "cash"
    buyer                 = business_transaction.buyer
    business_transaction.shipping_address = buyer.standard_address
    business_transaction.billing_address  = buyer.standard_address

    mail = BusinessTransactionMailer.buyer_notification( business_transaction )

    mail.must have_body_text( I18n.t( 'transaction.notifications.transport.pickup' ) )
    mail.must have_body_text( I18n.t( 'transaction.notifications.buyer.cash' ) )
  end

  it "should notify the buyer when paypal is selected" do
    business_transaction =  FactoryGirl.create :business_transaction_with_buyer, selected_payment: "paypal"
    buyer                 = business_transaction.buyer
    business_transaction.shipping_address = buyer.standard_address
    business_transaction.billing_address  = buyer.standard_address

    mail = BusinessTransactionMailer.buyer_notification( business_transaction )

    mail.must have_body_text( I18n.t( 'transaction.notifications.buyer.paypal' ) )
  end

  it "should notify the buyer when invoice is selected" do
    business_transaction =  FactoryGirl.create :business_transaction_with_buyer, selected_payment: "invoice"
    buyer                 = business_transaction.buyer
    business_transaction.shipping_address = buyer.standard_address
    business_transaction.billing_address  = buyer.standard_address

    mail = BusinessTransactionMailer.buyer_notification( business_transaction )

    mail.must have_body_text( I18n.t( 'transaction.notifications.buyer.invoice' ) )
  end

  it "should notify the buyer when cash_on_delivery is selected" do
    business_transaction =  FactoryGirl.create :business_transaction_with_buyer, selected_payment: "cash_on_delivery"
    buyer                 = business_transaction.buyer
    business_transaction.shipping_address = buyer.standard_address
    business_transaction.billing_address  = buyer.standard_address

    mail = BusinessTransactionMailer.buyer_notification( business_transaction )

    mail.must have_body_text( I18n.t( 'transaction.notifications.buyer.cash_on_delivery' ) )
  end

  it "should notify the buyer when bank_transfer is selected" do
    business_transaction =  FactoryGirl.create :business_transaction_with_buyer, selected_payment: "bank_transfer"
    buyer                 = business_transaction.buyer
    business_transaction.shipping_address = buyer.standard_address
    business_transaction.billing_address  = buyer.standard_address

    mail = BusinessTransactionMailer.buyer_notification( business_transaction )

    mail.must have_body_text( I18n.t( 'transaction.notifications.buyer.bank_transfer' ) )
  end

  it "should notify the buyer with a cancellation form" do
    business_transaction = FactoryGirl.create :business_transaction_with_buyer
    buyer                 = business_transaction.buyer
    business_transaction.shipping_address = buyer.standard_address
    business_transaction.billing_address  = buyer.standard_address
    business_transaction.article_seller_cancellation_form.stubs(:exists?).returns(true)
    business_transaction.article_seller_cancellation_form.stubs(:path).returns(Rails.root.join("test/fixtures/test.pdf"))

    mail = BusinessTransactionMailer.buyer_notification( business_transaction )

    mail.has_attachments?.must_equal true
  end
end
