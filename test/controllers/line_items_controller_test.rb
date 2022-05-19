#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  let(:cart) { create :cart, user: nil }
  let(:buyer) { create :buyer }
  let(:article) { create :article, :with_larger_quantity }
  let(:line_item) { create :line_item, cart: cart, article: article }

  describe "POST 'create'" do
    describe 'when the user is logged out' do
      describe 'and there is no cookie' do
        it "should create a new cart and it's cookie" do
          assert_difference 'Cart.count', 1 do
            post :create, params:{ line_item: { article_id: article.id } }
          end
          cookies.signed[:cart].must_equal Cart.last.id
        end
      end

      describe 'and there is a cookie' do
        it "should add the current item to the cart if that cart doesn't have a user_id" do
          create :cart # distraction cart
          cookies.signed[:cart] = cart.id
          post :create, params:{ line_item: { article_id: article.id } }
          cart.reload.line_items.map(&:article).must_include article
        end

        it 'should not add the current item to the cart if that cart has a user_id' do
          create :cart # distraction cart
          cookies.signed[:cart] = cart.id
          post :create, params:{ line_item: { article_id: article.id } }

          cart.reload.line_items.map(&:article).must_include article
        end
      end
    end

    describe 'when the user is logged in' do
      describe 'and there is no cookie' do
        before { sign_in buyer }

        it "should create a new cart and it's cookie if there is no existing cart" do
          assert_difference 'Cart.count', 1 do
            post :create, params:{ line_item: { article_id: article.id } }
          end
          cookies.signed[:cart].must_equal Cart.last.id
          Cart.last.user.must_equal buyer
        end

        it 'should use the old cart if there is an existing cart' do
          post :create, params:{ line_item: { article_id: article.id } }
          Cart.last.line_items.map(&:article).must_include article
          cookies.signed[:cart].must_equal Cart.last.id
        end
      end
    end
  end

  describe "PATCH 'update'" do
    it 'should update a given line_item' do
      line_item.reload.requested_quantity.must_equal 1
      cookies.signed[:cart] = line_item.cart.id
      patch :update, params:{ id: line_item.id, line_item: { requested_quantity: 2 } }
      line_item.reload.requested_quantity.must_equal 2
    end
    it 'should throw errors when requesting to much' do
      line_item.reload.requested_quantity.must_equal 1
      cookies.signed[:cart] = line_item.cart.id
      patch :update, params:{ id: line_item.id, line_item: { requested_quantity: (article.quantity_available + 1)  } }
      line_item.reload.requested_quantity.must_equal 1
      flash[:error].must_equal I18n.t('line_item.notices.error_quantity')
    end
    it 'should call destroy if quantity is 0' do
      line_item.reload.requested_quantity.must_equal 1
      cookies.signed[:cart] = line_item.cart.id
      assert_difference 'LineItem.count', -1 do
        patch :update, params:{ id: line_item.id, line_item: { requested_quantity: 0  } }
      end
    end
  end

  describe "DELETE 'destroy'" do
    it 'should delete a given line_item' do
      cookies.signed[:cart] = line_item.cart.id
      assert_difference 'LineItem.count', -1 do
        delete :destroy, params:{ id: line_item.id }
      end
    end
  end
end
