#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe UsersController do
  describe "GET 'show'" do
    describe 'for non-signed-in users' do
      before :each do
        @user = FactoryGirl.create(:user)
      end

      it 'should be successful' do
        get :show, id: @user
        assert_response :success
      end

      it 'render deleted user for banned users' do
        @user.update_attribute(:banned, true)
        get :show, id: @user
        assert_response :success
        assert_template :user_deleted
      end
    end

    describe 'for signed-in users' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it 'should be successful' do
        get :show, id: @user
        assert_response :success
      end
    end
  end

  describe "GET 'profile'" do
    before :each do
      @user = FactoryGirl.create(:legal_entity)
    end

    it 'should be successful' do
      get :profile, id: @user, format: :pdf, print: 'terms'
      assert_response :success
    end
  end

  describe 'GET contact' do
    let(:user) { FactoryGirl.create :user }

    it 'should be successful' do
      xhr :get, :contact, id: user.id
      assert_response :success
      assert_template :contact
    end
  end
end
