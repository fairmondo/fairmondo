require_relative '../test_helper'

describe CartMailer do
  include Rails.application.routes.url_helpers

  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:cart) { FactoryGirl.create(:cart, user: FactoryGirl.create(:user)) }
  let(:seller_line_item_group) { FactoryGirl.create(:line_item_group_with_items, :sold, seller: FactoryGirl.create(:user)) }
  let(:address) { FactoryGirl.create(:address) }

  it 'sends email to seller' do
    user = seller_line_item_group.seller
    user.standard_address = address
    mail = CartMailer.seller_email(seller_line_item_group)
    mail.must deliver_to(user.email)
  end

  #it 'sends email to buyer' do
  #  user = cart.user
  #  user.standard_address = address
  #  mail = CartMailer.buyer_email(cart)
  #  mail.must deliver_to(user.email)
  #end
end
