#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe CartsController do
  it 'should render empty cart template when user has no cart' do
    get :empty_cart
    assert_response :success
    assert_template :empty_cart
  end

  it 'should remove belboon token from user after cart is sold' do
    user = FactoryGirl.create :user, belboon_tracking_token: 'abcd,1234',
                                     belboon_tracking_token_set_at: Time.now
    cart = FactoryGirl.create :cart, :with_line_item_groups_from_legal_entity,
                              user: user, sold: true
    FactoryGirl.create :line_item_with_conventional_article,
                       line_item_group: cart.line_item_groups.first
    LineItem.any_instance.stubs(:qualifies_for_belboon?).returns true

    sign_in user
    get :show, id: cart.id
    assert_template :show
    user.reload.belboon_tracking_token.must_equal nil
    user.reload.belboon_tracking_token_set_at.must_equal nil
  end
end
