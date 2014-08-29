require_relative '../test_helper'

describe AddressesController do

  let(:user) { FactoryGirl.create :user }
  let(:address) { FactoryGirl.create :address, user: user }
  let(:referenced_address) { FactoryGirl.create :address, :referenced , user: user}

  describe 'GET ::new' do
    it 'should render addresse\'s new_template' do
      sign_in user
      xhr :get , :new, user_id: user.id
      assert_response :success
      assert_template :new
    end
  end

  describe 'POST ::create' do
    it 'should create new address' do
      @address_attrs = FactoryGirl.attributes_for :address
      sign_in user
      assert_difference('Address.count', 1) do
        xhr :post, :create, user_id: user.id, address: @address_attrs
      end
    end

    it 'should render new on error' do
      @address_attrs = FactoryGirl.attributes_for :address
      @address_attrs[:first_name] = nil
      sign_in user
      assert_no_difference('Address.count') do
        xhr :post, :create, user_id: user.id, address: @address_attrs
      end
      assert_template :new
    end
  end

  describe 'GET ::edit' do
    it 'should render addresse\'s edit_template' do
      sign_in user
      xhr :get, :edit, user_id: user.id, id: address.id
      assert_response :success
      assert_template :edit
    end
  end

  describe 'PATCH ::update' do
    it 'should update address' do
      @address_attrs = FactoryGirl.attributes_for :address, first_name: 'test update'
      update_address = FactoryGirl.create :address, user: user
      user.addresses << update_address
      sign_in user

      assert_no_difference('Address.count') do
        xhr :patch, :update, user_id: user.id, id: update_address.id, address: @address_attrs
      end
      update_address.reload.first_name.must_equal 'test update'
    end
    it 'should render edit on empty names' do
      @address_attrs = FactoryGirl.attributes_for :address, first_name: 'test update'
      @address_attrs[:first_name] = nil
      update_address = FactoryGirl.create :address, user: user
      user.addresses << update_address
      sign_in user

      assert_no_difference('Address.count') do
        xhr :patch, :update, user_id: user.id, id: update_address.id, address: @address_attrs
      end
      assert_template :edit
    end
    it 'should clone a referenced address' do
      @address_attrs = FactoryGirl.attributes_for :address, first_name: 'test update'
      referenced_address = FactoryGirl.create :address, :referenced, user: user
      fist_name_referenced = referenced_address.first_name
      user.addresses << referenced_address
      sign_in user

      assert_difference('Address.count', 1) do
        xhr :patch, :update, user_id: user.id, id: referenced_address.id, address: @address_attrs
      end
      referenced_address.reload.first_name.must_equal fist_name_referenced
      user.addresses.last.first_name.must_equal 'test update'
    end
  end

  describe 'DELETE ::destroy' do
    it 'should delete an address from the database' do
      user = FactoryGirl.create :incomplete_user
      address = FactoryGirl.create :address, user: user
      sign_in user
      address # can cause new addresses
      assert_difference('Address.count', -1) do
        xhr :delete, :destroy, user_id: user.id, id: address.id
      end
    end

    it 'should stash a referenced address from the database' do
      user = FactoryGirl.create :incomplete_user
      referenced_address = FactoryGirl.create :address, :referenced, user: user
      sign_in user
      referenced_address # can cause new addresses
      assert_difference('Address.count', 0) do
        xhr :delete, :destroy, user_id: referenced_address.user.id, id: referenced_address.id
      end
      referenced_address.reload.stashed?.must_equal true
    end
  end
end
