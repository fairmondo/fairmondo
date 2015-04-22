require_relative '../test_helper'

describe CartMailer do
  include Rails.application.routes.url_helpers

  include EmailSpec::Helpers
  include EmailSpec::Matchers

  it 'sends email to seller' do
    seller_line_item_group = FactoryGirl.create(:line_item_group, :with_business_transactions, :sold, create_line_items: true)
    user = seller_line_item_group.seller
    mail = CartMailer.seller_email(seller_line_item_group)
    mail.must deliver_to(user.email)
  end

  describe 'CartMailer#buyer_email' do
    let(:cart) do
      FactoryGirl.create :cart, :with_line_item_groups_from_legal_entity,
                         user: FactoryGirl.create(:user), sold: true
    end

    it 'sends email to buyer' do
      user = cart.user
      mail = CartMailer.buyer_email(cart)
      mail.must deliver_to(user.email)
    end

    it 'must contain courier terms when at least one transaction has
        selected_transport bike_courier' do
      FactoryGirl.create :business_transaction,
                         line_item_group_id: cart.line_item_groups.first.id
      BusinessTransaction.any_instance.stubs(:selected_transport)
        .returns('bike_courier')
      mail = CartMailer.buyer_email(cart)

      # Attachment
      attachment = mail.attachments['fahrwerk_kurierkollektiv_agb.pdf']
      attachment.filename.must_equal 'fahrwerk_kurierkollektiv_agb.pdf'
    end

    it 'must contain generated fair percent donation info' do
      cart.user.update_column :total_purchase_donations_cents, 111

      mail = CartMailer.buyer_email(cart)
      mail.must have_body_text I18n.t 'email.cart.buyer.total_donations',
                                      euro: '1,11 €'
    end

    it 'wont contain generated fair percent donation info if it is 0' do
      mail = CartMailer.buyer_email(cart)
      mail.wont have_body_text(
        'Mit Deinen Einkäufen hast Du Fairmondo bisher eine Spende'
      )
    end
  end

  it 'sends email to courier service' do
    business_transaction = FactoryGirl.create(:business_transaction, :transport_bike_courier, :paypal, state: 'ready')
    FactoryGirl.create :payment, line_item_group: business_transaction.line_item_group, state: 'confirmed'
    seller          = business_transaction.seller
    buyer           = business_transaction.buyer
    mail            = CartMailer.courier_notification(business_transaction)

    mail.must_deliver_to 'test@test.com'
    mail.must_bcc_to 'bybike@fairmondo.de'

    # Article information
    mail.must have_body_text(business_transaction.article_title)

    # Seller information
    mail.must have_subject('[Fairmondo] Artikel ausliefern')
    mail.must have_body_text(seller.fullname)
    mail.must have_body_text(seller.standard_address_first_name)
    mail.must have_body_text(seller.standard_address_last_name)
    mail.must have_body_text(seller.standard_address_address_line_1)
    mail.must have_body_text(seller.standard_address_address_line_1)
    mail.must have_body_text(seller.standard_address_city)
    mail.must have_body_text(seller.standard_address_zip)

    # Buyer information
    mail.must have_body_text(buyer.fullname)
    mail.must have_body_text(buyer.standard_address_first_name)
    mail.must have_body_text(buyer.standard_address_last_name)
    mail.must have_body_text(buyer.standard_address_address_line_1)
    mail.must have_body_text(buyer.standard_address_address_line_1)
    mail.must have_body_text(buyer.standard_address_city)
    mail.must have_body_text(buyer.standard_address_zip)

    # Info about Transaction
    mail.must have_body_text(business_transaction.bike_courier_time)
    mail.must have_body_text(business_transaction.bike_courier_message)
  end

  describe 'sending email on voucher payment' do |_variable|
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

  describe '#send_cart' do
    it 'sends open cart to specified email address' do
      cart = FactoryGirl.create :cart
      addr = 'test@test.com'
      mail = CartMailer.send_cart(cart.id, addr)

      mail.must deliver_to(addr)
      mail.must have_subject('[Fairmondo] Deine vorgemerkten Artikel auf Fairmondo')
    end
  end
end
