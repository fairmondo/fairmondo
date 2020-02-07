#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'user-management' do
    describe 'for non-signed-in users' do
      before :each do
        @user = create :user
      end

      it 'should deny access' do
        get :edit
        assert_redirected_to(new_user_session_path)
      end
    end

    describe 'for signed-in users' do
      before :each do
        @user = create :user

        sign_in @user
      end

      it 'should be successful' do
        get :edit
        assert_response :success
      end

      it 'should sucessfully update a user' do
        @attr = { about_me: 'Ich bin eine Profilbeschreibung', email: @user.email }

        put :update, params: { user: @attr }

        assert_redirected_to @user.reload
        @controller.instance_variable_get(:@user).about_me.must_equal @attr[:about_me]
      end
    end
  end

  describe '#create' do
    before(:each) do
      @valid_params = {
        user: {
          nickname:               'johndoe',
          email:                  'jdoe@example.com',
          password:               'password',
          legal:                  '1',
          type:                   'PrivateUser',
          voluntary_contribution: ''
        }
      }

      @valid_params2 = {
        user: {
          nickname:               'johndoe',
          email:                  'jdoe@example.com',
          password:               'password',
          legal:                  '1',
          type:                   'PrivateUser',
          voluntary_contribution: '5'
        }
      }

      ActionMailer::Base.deliveries.clear
    end

    it 'should send out an extra email if voluntary contribution was checked' do
      mail_mock = mock()
      mail_mock.expects(:deliver_later)
      RegistrationsMailer.expects(:voluntary_contribution_email).with('jdoe@example.com', 5).returns(mail_mock)

      post :create, params: @valid_params2
    end

    it 'should not send out an extra email if voluntary contribution was not checked' do
      post :create, params: @valid_params
      assert_equal 1, ActionMailer::Base.deliveries.size
    end
  end

  describe '#update' do
    it 'should still try to save the image on failed update' do
      user = create :user
      sign_in user
      Image.any_instance.expects(:save)
      put :update, params: { user: { nickname: user.nickname, image_attributes: attributes_for(:user_image) }, address: { first_name: '' } } # invalid params
    end
  end
end
