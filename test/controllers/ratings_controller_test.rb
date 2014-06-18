require_relative '../test_helper'

describe RatingsController do
  let(:seller){ FactoryGirl.create :user }
  let(:buyer){ FactoryGirl.create :user }
  let(:business_transaction){ FactoryGirl.create :business_transaction_with_buyer, seller: seller, buyer: buyer }

  describe 'GET ::index' do
    it 'should render rating\'s index_template' do
      get(:index, user_id: seller.id)
      assert_response :success
      assert_template(:index)
    end
  end

  describe 'POST ::create' do
    before do
      @rating_attrs = FactoryGirl.attributes_for(:rating, business_transaction_id: business_transaction.id)
      sign_in buyer
    end

    it 'should create new rating' do
      assert_difference 'Rating.count', 1 do
        post(:create, rating: @rating_attrs, user_id: seller.id)
      end
    end

    it 'should redirect to buyer\'s user profile' do
      post(:create, rating: @rating_attrs, business_transaction_id: business_transaction.id, user_id: seller.id)
      assert_redirected_to(user_path(buyer))
    end
  end

  describe 'GET ::new' do
    context 'for signed in user' do
      it 'should render ratings/new view' do
        sign_in buyer
        get(:new, user_id: seller.id, business_transaction_id: business_transaction.id)
        assert_response :success
      end
    end

    context 'for guest user' do
      it 'should not render ratings/new view' do
        get(:new, user_id: seller.id, business_transaction_id: business_transaction.id)
        assert_redirected_to(new_user_session_path)
      end
    end
  end

end
