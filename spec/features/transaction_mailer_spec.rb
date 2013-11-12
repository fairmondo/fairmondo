require "spec_helper"
require "email_spec"

describe TransactionMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  context "seller notification" do

    let( :transaction ) { FactoryGirl.create :transaction_with_buyer }
    let( :seller_notification ) { TransactionMailer.seller_notification( transaction ) }

    subject  { seller_notification }

    it "should be delivered to seller email" do
      subject.should deliver_to( transaction.seller.email )
    end

    it "should have right subject" do
      subject.should have_subject("[Fairnopoly] " + I18n.t('transaction.notifications.seller.seller_subject') + " (#{transaction.article_title})")
    end

    it "should contain email intro" do
     subject.should have_body_text(I18n.t('transaction.notifications.seller.intro'))
    end

    it "should show begin of email line" do
      subject.should have_body_text(I18n.t('transaction.notifications.begin'))
    end

    it "should have greeting with seller name" do
      subject.should have_body_text(I18n.t('transaction.notifications.greeting') + transaction.article_seller_forename + ',')
    end

    it "should have text for seller (herzlichen Glueckwunsch...)" do
      subject.should have_body_text(I18n.t('transaction.notifications.seller.seller_text'))
    end

    it "should have string: Angaben zum verkauften Artikel" do
      subject.should have_body_text(I18n.t('transaction.notifications.seller.order_infos'))
    end

    it "should have string: Der Kauf wurde durchgefuehrt von" do
      subject.should have_body_text(I18n.t('transaction.notifications.seller.pickup_info'))
    end

    it "should have string: Email Adresse der Verkaeuferin" do
      subject.should have_body_text(I18n.t('transaction.notifications.seller.buyer_email'))
    end

    it "should contain the buyer's email address" do
      subject.should have_body_text(transaction.buyer.email)
    end
  end

  context "seller notification with friendly_percent" do

    let ( :transaction_with_fp ) { FactoryGirl.create :transaction_with_friendly_percent_and_buyer }
    let ( :seller_notification_with_fp ) { TransactionMailer.seller_notification( transaction_with_fp ) }
    subject  { seller_notification_with_fp }


    it "should be delivered to seller email" do
      subject.should deliver_to( transaction_with_fp.seller.email )
    end

    it "should have right subject with fp" do
      subject.should have_subject("[Fairnopoly] " + I18n.t('transaction.notifications.seller.seller_subject') + " (#{transaction_with_fp.article_title})" +
      I18n.t('transaction.notifications.seller.with_donation_to') + "#{transaction_with_fp.article.donated_ngo.nickname}")
    end

    it "should have ngo contact when ngo has no bank data" do

    end

  end

  context "seller notification with friendly_percent and no bank data" do

    let ( :transaction_with_fp ) { FactoryGirl.create :transaction_with_friendly_percent_missing_bank_data_and_buyer }
    let ( :seller_notification_with_fp ) { TransactionMailer.seller_notification( transaction_with_fp ) }
    subject  { seller_notification_with_fp }

    it "should have ngo contact when ngo has no bank data" do
      subject.should have_body_text(I18n.t('transaction.notifications.seller.no_bank_acount'))
    end

  end

  context "buyer notification" do
    let( :transaction ) { FactoryGirl.create :transaction_with_buyer }
    let( :buyer_notitfication ) { TransactionMailer.buyer_notification( transaction ) }
    subject { buyer_notitfication }

    it "should be delivererd to buyer email" do
      subject.should deliver_to( transaction.buyer_email )
    end

    it "should have the right subject" do
      subject.should have_subject("[Fairnopoly] " + I18n.t('transaction.notifications.buyer.buyer_subject') + " (#{transaction.article_title})")
    end

    it "should contain email intro" do
      subject.should have_body_text(I18n.t('transaction.notifications.buyer.intro'))
    end

    it "should show begin of email line" do
      subject.should have_body_text(I18n.t('transaction.notifications.begin'))
    end

    it "should have greeting with buyer name" do
      subject.should have_body_text(I18n.t('transaction.notifications.greeting') + transaction.buyer_forename + ',')
    end

    it "should have text for seller (Vielen Dank...)" do
      subject.should have_body_text(I18n.t('transaction.notifications.buyer.buyer_text'))
    end

    it "should have security warning" do
      subject.should have_body_text(I18n.t('transaction.notifications.buyer.security_warning'))
    end

    it "should have string: Angaben zu Deiner Bestellung" do
      subject.should have_body_text(I18n.t('transaction.notifications.buyer.order_infos'))
    end

    it "should contain seller's email address" do
      subject.should have_body_text( transaction.seller.email )
    end

    it "should contain title of article" do
      subject.should have_body_text( transaction.article_title )
    end

    it "should contain link to article" do
      subject.should have_body_text( "/articles/#{transaction.article.slug}" )
    end

    it "should contain link to transaction" do
      subject.should have_body_text( "transactions/#{transaction.id}" )
    end

    # it "should contain string: Bitte gib bei..." do
    #   subject.should have_body_text( I18n.t( 'transaction.notifications.buyer.transaction_id_info', id: transaction.id ) )
    # end

    # it "should contain transaction id" do
    #   subject.should have_body_text( transaction.id )
    # end

    context "pickup" do
      before do
        transaction.selected_transport = "pickup"
      end

      it "should have string: Selbstabholung" do
        subject.should have_body_text( I18n.t( 'transaction.notifications.transport.pickup' ) )
      end
    end

    context "PayPal" do
      before do
        transaction.selected_payment = "paypal"
      end

      it "should contain string: PayPal" do
        subject.should have_body_text( I18n.t( 'transaction.notifications.buyer.paypal' ) )
      end
    end

    context "cash" do
      before do
        transaction.selected_payment = "cash"
      end

      it "should contain string: Barzahlung bei Abholung" do
        subject.should have_body_text( I18n.t( 'transaction.notifications.buyer.cash' ) )
      end
    end

    context "invoice" do
      before do
        transaction.selected_payment = "invoice"
      end

      it "should contain string: Rechnung" do
        subject.should have_body_text( I18n.t( 'transaction.notifications.buyer.invoice' ) )
      end
    end

    context "cash_on_delivery" do
      before do
        transaction.selected_payment = "cash_on_delivery"
      end

      it "should contain string: Nachnahme" do
        subject.should have_body_text( I18n.t( 'transaction.notifications.buyer.invoice' ) )
      end
    end

    context "bank_transfer" do
      before do
        transaction.selected_payment = "bank_transfer"
      end

      it "should contain string: Ueberweisung" do
        subject.should have_body_text( I18n.t( 'transaction.notifications.buyer.bank_transfer' ) )
      end
    end
  end
end
