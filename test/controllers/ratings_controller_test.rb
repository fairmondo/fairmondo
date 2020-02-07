#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class RatingsControllerTest < ActionController::TestCase
  let(:seller) { create :user }
  let(:buyer) { create :user }
  let(:line_item_group) { create :line_item_group, seller: seller, buyer: buyer }

  describe 'GET ::index' do
    it 'should render rating\'s index_template' do
      get :index, params: { user_id: seller.id }
      assert_response :success
      assert_template(:index)
    end
  end

  describe 'POST ::create' do
    before do
      # TODO: Use attributes_for if possible after ratings are refactored
      @rating_attrs = { rating: 'positive', line_item_group_id: line_item_group.id }
      sign_in buyer
    end

    it 'should create new rating' do
      assert_difference 'Rating.count', 1 do
        post :create, params: { rating: @rating_attrs, user_id: seller.id }
      end
    end

    it 'should redirect to buyer\'s user profile' do
      post:create, params: { rating: @rating_attrs, line_item_group_id: line_item_group.id, user_id: seller.id }
      assert_redirected_to(user_path(buyer))
    end
  end

  describe 'GET ::new' do
    context 'for signed in user' do
      it 'should render ratings/new view' do
        sign_in buyer
        get :new, params: { user_id: seller.id, line_item_group_id: line_item_group.id }
        assert_response :success
      end
    end

    context 'for guest user' do
      it 'should not render ratings/new view' do
        get :new, params: { user_id: seller.id, line_item_group_id: line_item_group.id }
        assert_redirected_to(new_user_session_path)
      end
    end
  end
end
