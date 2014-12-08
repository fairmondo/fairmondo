require_relative '../test_helper'

describe CartMailer do
  include Rails.application.routes.url_helpers

  include EmailSpec::Helpers
  include EmailSpec::Matchers

  it 'sends email to seller' do
    seller_line_item_group = FactoryGirl.create(:line_item_group, :with_business_transactions, :sold)
    user = seller_line_item_group.seller
    mail = CartMailer.seller_email(seller_line_item_group)
    mail.must deliver_to(user.email)
  end

  it 'sends email to buyer' do
    cart = FactoryGirl.create(:cart, :with_line_item_groups_from_legal_entity, user: FactoryGirl.create(:user), sold: true)
    user = cart.user
    mail = CartMailer.buyer_email(cart)
    mail.must deliver_to(user.email)
  end

  describe "sending email on voucher payment" do |variable|
    it 'displays donated money' do
      payment = FactoryGirl.create :voucher_payment, pay_key: '999999999a'
      seller = payment.line_item_group.seller
      mail = CartMailer.voucher_paid_email(payment.id)
      mail.must deliver_to(seller.email)
      mail.must have_body_text 'Dadurch ist ein Spendenbetrag von'
    end

    it 'displays missing money' do
      payment = FactoryGirl.create :voucher_payment, pay_key: '1a'
      seller = payment.line_item_group.seller
      mail = CartMailer.voucher_paid_email(payment.id)
      mail.must deliver_to(seller.email)
      mail.must have_body_text 'werden von dem/der Käufer*in überwiesen'
    end
  end
end
