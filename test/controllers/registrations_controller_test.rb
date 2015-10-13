#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe RegistrationsController do
  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'user-management' do
    describe 'for non-signed-in users' do
      before :each do
        @user = FactoryGirl.create(:user)
      end

      it 'should deny access' do
        get :edit
        assert_redirected_to(new_user_session_path)
      end
    end

    describe 'for signed-in users' do
      before :each do
        @user = FactoryGirl.create(:user)

        sign_in @user
      end

      it 'should be successful' do
        get :edit
        assert_response :success
      end

      it 'should sucessfully update a user' do
        @attr = { about_me: 'Ich bin eine Profilbeschreibung', email: @user.email }

        put :update, user: @attr

        assert_redirected_to @user.reload
        @controller.instance_variable_get(:@user).about_me.must_equal @attr[:about_me]
      end
    end
  end

  describe '#create' do
    before(:each) do
      @valid_params = {
        user: {
          nickname: 'johndoe',
          email:    'jdoe@example.com',
          password: 'password',
          legal:    '1',
          type:     'PrivateUser'
        }
      }
    end
  end

  describe '#update' do
    it 'should still try to save the image on failed update' do
      user = FactoryGirl.create(:user)
      sign_in user
      Image.any_instance.expects(:save)
      put :update, user: { nickname: user.nickname, image_attributes: FactoryGirl.attributes_for(:user_image) }, address: { first_name: '' } # invalid params
    end
  end
end
