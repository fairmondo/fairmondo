require_relative '../test_helper'

describe LineItemsController do
  let(:cart) { FactoryGirl.create(:cart, user: buyer) }
  let(:buyer) { FactoryGirl.create(:buyer) }
  let(:article) { FactoryGirl.create(:article) }
  let(:line_item) { FactoryGirl.create(:line_item) }

  describe "POST 'create'" do
    describe "when the user is logged out" do
      describe "and there is no cookie" do
        it "should create a new cart and it's cookie" do
          assert_difference 'Cart.count', 1 do
            post :create, article_id: article.id
          end
          cookies[:cart].must_equal 1
        end
      end

      describe "and there is a cookie" do
        it "should add the current item to the cart if that cart doesn't have a user_id" do
          FactoryGirl.create(:cart) # distraction cart
          @request.cookies[:cart] = cart.id
          post :create, article_id: article.id

          cart.line_items.map(&:article).must_include article
        end

        it "should not add the current item to the cart if that cart has a user_id" do
          FactoryGirl.create(:cart) # distraction cart
          @request.cookies[:cart] = cart.id
          post :create, article_id: article.id

          cart.line_items.map(&:article).must_include article
        end
      end
    end

    describe "when the user is logged in" do
      describe "and there is no cookie" do
        before { sign_in buyer }

        it "should create a new cart and it's cookie if there is no existing cart" do
          assert_difference 'Cart.count', 1 do
            post :create, article_id: article.id
          end
          cookies[:cart].must_equal 1
          Cart.find(1).user.must_equal buyer
        end

        it "should use the old cart if there is an existing cart" do
          post :create, article_id: article.id
          Cart.last.line_items.map(&:article).must_include article
          cookies[:cart].must_equal 1
        end
      end
    end
  end

  describe "PATCH 'update'" do
    it "should update a given line_item" do
      line_item.reload.requested_quantity.must_equal 1
      patch :update, id: line_item.id, requested_quantity: 2
      line_item.reload.requested_quantity.must_equal 2
    end
  end

  describe "DELETE 'destroy'" do
    it "should delete a given line_item" do
      line_item
      assert_difference 'LineItem.count', -1 do
        delete :destroy, id: line_item.id
      end
    end
  end
end
