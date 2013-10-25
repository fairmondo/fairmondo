require "spec_helper"
require "email_spec"

describe TransactionMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  context "seller notification" do
    let ( :transaction ) { FactoryGirl.create :transaction_with_buyer }
    let ( :seller_notification ) { TransactionMailer.seller_notification( transaction ) } 
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
end
