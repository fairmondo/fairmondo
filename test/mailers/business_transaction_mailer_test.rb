require "test_helper"
require "email_spec"

describe BusinessTransactionMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  context "seller notification" do

    let( :business_transaction ) { FactoryGirl.create :business_transaction_with_buyer }
    let( :seller_notification ) { BusinessTransactionMailer.seller_notification( business_transaction ) }

    subject  { seller_notification }

    it "should be delivered to seller email" do
      should deliver_to( business_transaction.seller.email )
    end

    it "should have right subject" do
      should have_subject("[Fairnopoly] " + I18n.t('transaction.notifications.seller.seller_subject') + " (#{business_transaction.article_title})")
    end

    it "should contain email intro" do
     should have_body_text(I18n.t('transaction.notifications.seller.intro'))
    end

    it "should have greeting with seller name" do
      should have_body_text(I18n.t('transaction.notifications.greeting') + business_transaction.article_seller_forename + ',')
    end

    it "should have string: Angaben zum verkauften Artikel" do
      should have_body_text(I18n.t('transaction.notifications.seller.order_infos'))
    end

    it "should have string: Der Kauf wurde durchgefuehrt von" do
      should have_body_text(I18n.t('transaction.notifications.seller.pickup_info'))
    end

    it "should have string: Email Adresse der Verkaeuferin" do
      should have_body_text(I18n.t('transaction.notifications.seller.buyer_email'))
    end

    it "should contain the buyer's email address" do
      should have_body_text(business_transaction.buyer.email)
    end
  end

  context "seller notification with friendly_percent" do

    let(:business_transaction_with_fp ) { FactoryGirl.create :business_transaction_with_friendly_percent_and_buyer }
    let(:seller_notification_with_fp ) { BusinessTransactionMailer.seller_notification( business_transaction_with_fp ) }
    subject  { seller_notification_with_fp }


    it "should be delivered to seller email" do
      subject.should deliver_to( business_transaction_with_fp.seller.email )
    end

    it "should have right subject with fp" do
      subject.should have_subject("[Fairnopoly] " + I18n.t('transaction.notifications.seller.seller_subject') + " (#{business_transaction_with_fp.article_title})" +
      I18n.t('transaction.notifications.seller.with_donation_to') + "#{business_transaction_with_fp.article.friendly_percent_organisation_nickname}")
    end

  end

  context "seller notification with friendly_percent and no bank data" do

    let( :business_transaction_with_fp ) { FactoryGirl.create :business_transaction_with_friendly_percent_missing_bank_data_and_buyer }
    let( :seller_notification_with_fp ) { BusinessTransactionMailer.seller_notification( business_transaction_with_fp ) }
    subject  { seller_notification_with_fp }

    it "should have ngo contact when ngo has no bank data" do
      subject.should have_body_text(I18n.t('transaction.notifications.seller.no_bank_acount'))
    end

  end

  context "buyer notification" do
    let( :business_transaction ) { FactoryGirl.create :business_transaction_with_buyer }
    let( :buyer_notitfication ) { BusinessTransactionMailer.buyer_notification( business_transaction ) }
    subject { buyer_notitfication }

    it "should be delivererd to buyer email" do
      should deliver_to( business_transaction.buyer_email )
    end

    it "should have the right subject" do
      should have_subject("[Fairnopoly] " + I18n.t('transaction.notifications.buyer.buyer_subject') + " (#{business_transaction.article_title})")
    end

    it "should contain email intro" do
      should have_body_text(I18n.t('transaction.notifications.buyer.intro'))
    end

    it "should have greeting with buyer name" do
      should have_body_text(I18n.t('transaction.notifications.greeting') + business_transaction.buyer_forename + ',')
    end

    it "should have security warning" do
      should have_body_text(I18n.t('transaction.notifications.buyer.security_warning'))
    end

    it "should have string: Angaben zu Deiner Bestellung" do
      should have_body_text(I18n.t('transaction.notifications.buyer.order_infos'))
    end

    it "should contain seller's email address" do
      should have_body_text(business_transaction.seller.email )
    end

    it "should contain title of article" do
      should have_body_text( business_transaction.article_title )
    end

    it "should contain link to article" do
      should have_body_text( "/articles/#{business_transaction.article.slug}" )
    end

    it "should contain link to transaction" do
      should have_body_text( "business_transactions/#{business_transaction.id}" )
    end

    context "pickup" do
      before do
        business_transaction.selected_transport = "pickup"
      end

      it "should have string: Selbstabholung" do
        should have_body_text( I18n.t( 'transaction.notifications.transport.pickup' ) )
      end
    end

    context "PayPal" do
      before do
        business_transaction.selected_payment = "paypal"
      end

      it "should contain string: PayPal" do
        should have_body_text( I18n.t( 'transaction.notifications.buyer.paypal' ) )
      end
    end

    context "cash" do
      before do
        business_transaction.selected_payment = "cash"
      end

      it "should contain string: Barzahlung bei Abholung" do
        should have_body_text( I18n.t( 'transaction.notifications.buyer.cash' ) )
      end
    end

    context "invoice" do
      before do
        business_transaction.selected_payment = "invoice"
      end

      it "should contain string: Rechnung" do
        should have_body_text( I18n.t( 'transaction.notifications.buyer.invoice' ) )
      end
    end

    context "cash_on_delivery" do
      before do
        business_transaction.selected_payment = "cash_on_delivery"
      end

      it "should contain string: Nachnahme" do
        should have_body_text( I18n.t( 'transaction.notifications.buyer.invoice' ) )
      end
    end

    context "bank_transfer" do
      before do
        business_transaction.selected_payment = "bank_transfer"
      end

      it "should contain string: Ueberweisung" do
        should have_body_text( I18n.t( 'transaction.notifications.buyer.bank_transfer' ) )
      end
    end

    context "seller has cancellation form" do
      it "should have the cancellation form as attachment" do
        business_transaction.article_seller_cancellation_form.stub(:exists?).and_return(true)
        business_transaction.article_seller_cancellation_form.stub(:path).and_return(Rails.root.join("spec/fixtures/test.pdf"))
        should have_attachments
      end
    end
  end
end
