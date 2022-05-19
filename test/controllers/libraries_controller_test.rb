#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class LibrariesControllerTest < ActionController::TestCase
  describe "GET 'index" do
    describe 'for non-signed-in users' do
      before :each do
        @user = create :user
      end

      it 'should allow access' do
        get :index, params:{ user_id: @user.id }
        assert_response :success
      end
    end

    describe 'for signed-in users' do
      before :each do
        @library = create :library

        sign_in @library.user
      end

      it 'should be successful' do
        get :index, params:{ user_id: @library.user }
        assert_response :success
      end

      it 'should be successful' do
        get :show, params:{ user_id: @library.user, id: @library.id }
        assert_response :success
      end
    end

    describe "with parameter 'mode=myfavorite'" do
      it 'should be successful if user is logged in' do
        user = create :user
        @controller.stubs(:current_user).returns(user)
        get :index, params:{ mode: 'myfavorite' }
        assert_response :success
      end
    end

    describe "with parameter 'mode=new'" do
      it 'should be successful' do
        get :index, params:{ mode: 'new' }
        assert_response :success
      end
    end

    describe "with parameter 'mode=trending'" do
      it 'should be successful' do
        get :index, params:{ mode: 'trending' }
        assert_response :success
      end
    end

    describe "with parameter 'iframe=true'" do
      it 'should render the iframe layout' do
        get :index, params:{ iframe: true }
        assert_template layout: 'iframe'
      end
    end

    # describe '::focus' do
    #   it 'should return trending libraries if no user is focused and no mode is set' do
    #     @controller.stubs(:user_focused?).returns(false)
    #     User.any_instance.expects(:libraries).never
    #     #Library.expects(:trending) # in case this gets switched back
    #     @controller.send(:focus)
    #   end
    # end
  end

  describe '#create' do
    it 'should return a library with auditing disabled' do
    end
  end

  describe '#update' do
    it 'should disable auditing for welcome page' do
    end
  end

  describe '#admin_audit' do
    let(:library) { create :library }

    it 'should toggle library audit status via ajax' do
      user = create :admin_user
      sign_in user

      # audited should be false when library is created...
      assert_equal(library.audited, false)

      # ...true after first request...
      patch :admin_audit, params: { id: library.id }, xhr: true
      assert_equal(library.reload.audited, true)
      assert_response :success

      # ...false after second request.
      patch :admin_audit, params: { id: library.id }, xhr: true
      assert_equal(library.reload.audited, false)
      assert_response :success
    end
  end
end
