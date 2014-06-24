require_relative '../test_helper'

describe LineItemsController do
  let(:cart) { FactoryGirl.create(:cart, user: buyer) }
  let(:buyer) { FactoryGirl.create(:buyer) }
  let(:business_transaction) { FactoryGirl.create(:business_transaction) }

  describe "POST 'create'" do
    it "should add the current item to a cart cookie if one exists" do
      FactoryGirl.create(:cart) # distraction cart
      @request.cookies[:cart] = cart.id
      post :create, business_transaction_id: business_transaction.id

      cart.line_items.map(&:business_transaction).must_include business_transaction
    end

    describe "when the user is logged out and there is no cookie" do
      it "should create a new cart and it's cookie" do
        assert_difference 'Cart.count', 1 do
          post :create, business_transaction_id: business_transaction.id
        end
        cookies[:cart].must_equal 1
      end
    end

    describe "when the user is logged in and there is no cookie" do
      before { sign_in buyer }

      it "should create a new cart and it's cookie if there is no existing cart" do
        assert_difference 'Cart.count', 1 do
          post :create, business_transaction_id: business_transaction.id
        end
        cookies[:cart].must_equal 1
        Cart.find(1).user.must_equal buyer
      end

      it "should use the old cart if there is an existing cart" do
        post :create, business_transaction_id: business_transaction.id
        Cart.last.line_items.map(&:business_transaction).must_include business_transaction
        cookies[:cart].must_equal 1
      end
    end
  end
end
