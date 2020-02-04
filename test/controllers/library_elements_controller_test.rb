#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

class LibraryElementsControllerTest < ActionController::TestCase
  describe 'Library Elements' do
    describe 'for non-signed-in users' do
      before :each do
        @user = create :user
        @library_element = create :library_element
      end

      it 'should deny access to create' do
        put :create, user_id: @user
        assert_redirected_to(new_user_session_path)
      end

      it 'should deny access to destroy' do
        put :destroy, user_id: @user, id: @library_element
        assert_redirected_to(new_user_session_path)
      end
    end

    describe 'for signed-in users' do
      before :each do
        @library_element = create :library_element
        @library = create :library
        @user = @library_element.library.user
        @different_library_element = create :library_element
        @different_user = @different_library_element.library.user
        sign_in @user
      end

      it 'destroy a library element' do
        assert_difference 'LibraryElement.count', -1 do
          delete :destroy, user_id: @user, id: @library_element
        end
      end

      it 'shouldnt be possible to delete another users elements' do
        @user.id.wont_be_same_as @different_user.id # by design
        -> { delete :destroy, user_id: @different_user, id: @different_library_element }.must_raise(Pundit::NotAuthorizedError)
      end

      it 'shouldnt be possible to add elements to another users libraries' do
        @user.id.wont_be_same_as @different_user.id # by design
        -> do
          post :create, user_id: @different_user, library_element: { library_id: @different_library_element.library }
        end.must_raise(Pundit::NotAuthorizedError)
      end
    end
  end
end
