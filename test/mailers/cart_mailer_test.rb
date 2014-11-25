require_relative '../test_helper'

describe CartMailer do
  include Rails.application.routes.url_helpers

  include EmailSpec::Helpers
  include EmailSpec::Matchers

  it 'sends email to seller' do
    seller_line_item_group =  FactoryGirl.create(:line_item_group, :with_business_transactions, :sold)
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

  it 'sends email to courier service' do
    line_item_group = FactoryGirl.create(:line_item_group, :with_business_transactions, :sold)
    seller          = line_item_group.seller
    buyer           = line_item_group.buyer
    mail            = CartMailer.courier_notification(line_item_group)

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

  end
end
