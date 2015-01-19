require_relative '../test_helper'

describe CartsController do
  it 'should render empty cart template when user has no cart' do
    get :empty_cart
    assert_response :success
    assert_template :empty_cart
  end
end
