require_relative '../test_helper'

describe LineItemsController do
  let(:cart) { FactoryGirl.create(:cart, user: nil) }
  let(:buyer) { FactoryGirl.create(:buyer) }
  let(:article) { FactoryGirl.create(:article, :with_larger_quantity) }
  let(:line_item) { FactoryGirl.create(:line_item, cart: cart, article: article) }

  describe "POST 'create'" do
    describe "when the user is logged out" do
      describe "and there is no cookie" do
        it "should create a new cart and it's cookie" do
          assert_difference 'Cart.count', 1 do
            post :create, line_item: { article_id: article.id }
          end
          cookies.signed[:cart].must_equal 1
        end
      end

      describe "and there is a cookie" do
        it "should add the current item to the cart if that cart doesn't have a user_id" do
          FactoryGirl.create(:cart) # distraction cart
          cookies.signed[:cart] = cart.id
          post :create, line_item: { article_id: article.id }
          cart.reload.line_items.map(&:article).must_include article
        end

        it "should not add the current item to the cart if that cart has a user_id" do
          FactoryGirl.create(:cart) # distraction cart
          cookies.signed[:cart] = cart.id
          post :create, line_item: { article_id: article.id }

          cart.reload.line_items.map(&:article).must_include article
        end
      end
    end

    describe "when the user is logged in" do
      describe "and there is no cookie" do
        before { sign_in buyer }

        it "should create a new cart and it's cookie if there is no existing cart" do
          assert_difference 'Cart.count', 1 do
            post :create, line_item: { article_id: article.id }
          end
          cookies.signed[:cart].must_equal 1
          Cart.find(1).user.must_equal buyer
        end

        it "should use the old cart if there is an existing cart" do
          post :create, line_item: { article_id: article.id }
          Cart.last.line_items.map(&:article).must_include article
          cookies.signed[:cart].must_equal 1
        end
      end
    end
  end

  describe "PATCH 'update'" do
    it "should update a given line_item" do
      line_item.reload.requested_quantity.must_equal 1
      cookies.signed[:cart] = line_item.cart.id
      patch :update, id: line_item.id, line_item: { requested_quantity: 2 }
      line_item.reload.requested_quantity.must_equal 2
    end
    it "should throw errors when requesting to much" do
      line_item.reload.requested_quantity.must_equal 1
      cookies.signed[:cart] = line_item.cart.id
      patch :update, id: line_item.id, line_item: { requested_quantity: (article.quantity_available + 1)  }
      line_item.reload.requested_quantity.must_equal article.quantity_available
      flash[:error].must_equal I18n.t('line_item.notices.error_quanitity')
    end
    it "should call destroy if quantity is 0" do
      line_item.reload.requested_quantity.must_equal 1
      cookies.signed[:cart] = line_item.cart.id
      assert_difference 'LineItem.count', -1 do
        patch :update, id: line_item.id, line_item: { requested_quantity: 0  }
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "should delete a given line_item" do
      cookies.signed[:cart] = line_item.cart.id
      assert_difference 'LineItem.count', -1 do
        delete :destroy, id: line_item.id
      end
    end
  end
end
