require_relative '../test_helper'

describe CartsController do
  it 'should render empty cart template when user has no cart' do
    get :empty_cart
    assert_response :success
    assert_template :empty_cart
  end

# it 'should render send_via_email form' do
#   cart = FactoryGirl.create :cart
#
#   get :send_via_email, cart_id: cart.id
#   assert_response :success
#   assert_template :send_via_email
# end
end
