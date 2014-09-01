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
    cart = FactoryGirl.create(:cart, :with_line_item_groups, user: FactoryGirl.create(:user))
    user = cart.user
    mail = CartMailer.buyer_email(cart)
    mail.must deliver_to(user.email)
  end
end
