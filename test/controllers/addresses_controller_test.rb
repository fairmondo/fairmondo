require_relative '../test_helper'

describe AddressesController do
  let(:user){ FactoryGirl.create :user }
  let(:address){ FactoryGirl.create :address, user_id: user.id }

  describe 'GET ::index' do
    it 'should render addresse\'s index_template' do
      get(:index, user_id: user.id)
      assert_response :success
      assert_template(:index)
    end
  end

  describe 'GET ::new' do
    it 'should render addresse\'s new_template' do
      sign_in user
      get :new, user_id: user.id
      assert_response :success
    end
  end

  describe 'POST ::create' do
    it 'should create new address' do
      @address_attrs = FactoryGirl.attributes_for :address
      sign_in user
      assert_difference 'Address.count', 1 do
        post :create, user_id: user.id, address: @address_attrs
      end
    end
  end

  describe 'GET ::edit' do
    it 'should render addresse\'s edit_template' do
      sign_in user
      get :edit, user_id: user.id, id: address.id
      assert_response :success
    end
  end
end
