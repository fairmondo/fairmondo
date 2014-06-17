#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'test_helper'

describe LibraryElementsController do

  describe 'Library Elements' do
    describe 'for non-signed-in users' do
      before :each do
        @user = FactoryGirl.create(:user)
        @library_element = FactoryGirl.create(:library_element)
      end

      it 'should deny access to create' do
        put :create, :user_id => @user
        assert_redirected_to(new_user_session_path)
      end

      it 'should deny access to destroy' do
        put :destroy, :user_id => @user, :id => @library_element
        assert_redirected_to(new_user_session_path)
      end
    end

    describe 'for signed-in users' do
      before :each do
        @library_element= FactoryGirl.create(:library_element)
        @library = FactoryGirl.create(:library)
        @user = @library_element.library.user
        @different_library_element= FactoryGirl.create(:library_element)
        @different_user = @different_library_element.library.user
        sign_in @user
      end

      it 'destroy a library element' do
        assert_difference 'LibraryElement.count', -1 do
          delete :destroy,:user_id => @user, :id => @library_element
        end
      end

      it 'shouldnt be possible to delete another users elements' do
        @user.id.wont_be_same_as @different_user.id #by design
        -> { delete :destroy,:user_id => @different_user, :id => @different_library_element }.must_raise(Pundit::NotAuthorizedError)
      end

      it 'shouldnt be possible to add elements to another users libraries' do
        @user.id.wont_be_same_as @different_user.id #by design
         -> {
          post :create ,:user_id => @different_user, :library_element => {:library_id => @different_library_element.library }
        }.must_raise(Pundit::NotAuthorizedError)
      end
    end
  end
end
