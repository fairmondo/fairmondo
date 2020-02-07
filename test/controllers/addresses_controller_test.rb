#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class AddressesControllerTest < ActionController::TestCase
  let(:user) { create :user }
  let(:address) { create :address, user: user }
  let(:referenced_address) { create :address, :referenced, user: user }

  describe 'GET ::new' do
    it 'should render addresse\'s new_template' do
      sign_in user
      get :new, params: { user_id: user.id }, xhr: true
      assert_response :success
      assert_template :new
    end
  end

  describe 'POST ::create' do
    it 'should create new address' do
      @address_attrs = attributes_for :address
      sign_in user
      assert_difference('Address.count', 1) do
        post :create, params: { user_id: user.id, address: @address_attrs }, xhr: true
      end
    end

    it 'should render new on error' do
      @address_attrs = attributes_for :address
      @address_attrs[:first_name] = nil
      sign_in user
      assert_no_difference('Address.count') do
        post :create, params: { user_id: user.id, address: @address_attrs }, xhr: true
      end
      assert_template :new
    end
  end

  describe 'GET ::edit' do
    it 'should render addresse\'s edit_template' do
      sign_in user
      get :edit, params: { user_id: user.id, id: address.id }, xhr: true
      assert_response :success
      assert_template :edit
    end
  end

  describe 'PATCH ::update' do
    it 'should update address' do
      @address_attrs = attributes_for :address, first_name: 'test update'
      update_address = create :address, user: user
      user.addresses << update_address
      sign_in user

      assert_no_difference('Address.count') do
        patch :update, params: { user_id: user.id, id: update_address.id, address: @address_attrs }, xhr: true
      end
      update_address.reload.first_name.must_equal 'test update'
    end

    it 'should render edit on empty names' do
      @address_attrs = attributes_for :address, first_name: 'test update'
      @address_attrs[:first_name] = nil
      update_address = create :address, user: user
      user.addresses << update_address
      sign_in user

      assert_no_difference('Address.count') do
        patch :update, params: { user_id: user.id, id: update_address.id, address: @address_attrs }, xhr: true
      end
      assert_template :edit
    end

    it 'should clone a referenced address' do
      @address_attrs = attributes_for :address, first_name: 'test update'
      referenced_address = create :address, user: user
      create(:line_item_group, payment_address: referenced_address)
      fist_name_referenced = referenced_address.first_name
      user.addresses << referenced_address
      sign_in user

      assert_difference('Address.count', 1) do
        patch :update, params: { user_id: user.id, id: referenced_address.id, address: @address_attrs }, xhr: true
      end
      referenced_address.reload.first_name.must_equal fist_name_referenced
      user.addresses.last.first_name.must_equal 'test update'
    end
  end

  describe 'DELETE ::destroy' do
    it 'should delete an address from the database' do
      user = create :incomplete_user
      address = create :address, user: user
      sign_in user
      assert_difference('Address.count', -1) do
        delete :destroy, params: { user_id: user.id, id: address.id }, xhr: true
      end
    end

    it 'should stash a referenced address from the database' do
      user = create :incomplete_user
      referenced_address = create :address, user: user
      create(:line_item_group, payment_address: referenced_address)
      sign_in user
      assert_difference('Address.count', 0) do
        delete :destroy, params: { user_id: referenced_address.user.id, id: referenced_address.id }, xhr: true
      end
      referenced_address.reload.stashed?.must_equal true
    end
  end
end
