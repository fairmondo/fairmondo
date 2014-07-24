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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly. If not, see <http://www.gnu.org/licenses/>.
#
#

require_relative "../test_helper"

describe CommentsController do
  describe "GET comments on library" do
    before :each do
      @library = FactoryGirl.create(:library, public: true)
      @user = FactoryGirl.create(:user)
      @comment = FactoryGirl.create(:comment,
                                 text: "Test comment",
                                 commentable: @library,
                                 user: @user)
    end

    it "should return the comments of the library for guests" do
      xhr(:get, :index, library_id: @library.id,
                        comments_page: 1)

      assert_response :success
    end

    it "should return the comments of the library for logged in users" do
      sign_in @user
      xhr(:get, :index, library_id: @library.id,
                        comments_page: 1)

      assert_response :success
    end
  end

  describe "POST comment on library" do
    before :each do
      @library = FactoryGirl.create(:library)
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    describe "with valid params" do
      it "should allow posting using ajax" do
        post :create, comment: { text: "test" },
                      library_id: @library.id,
                      format: :js

        assert_response :success
        assert_nil(assigns(:message))
      end
    end

    describe "with invalid params" do
      it "does not increase the comment count" do
        assert_difference "@library.comments.count", 0 do
          post :create, comment: { text: "test" },
                        library_id: @library.id + 1,
                        format: :js
        end
      end

      it "should set the flash" do
        post :create, comment: { text: nil },
                      library_id: @library.id + 1,
                      format: :js

        @controller.instance_variable_get(:@message)
          .must_equal(I18n.t('flash.actions.create.alert', @controller.instance_variable_get(:@comment)))
      end
    end
  end

  describe "DELETE comment on library" do
    before :each do
      @library = FactoryGirl.create(:library)
      @user = FactoryGirl.create(:user)
      sign_in @user
      @comment = FactoryGirl.create(:comment,
                                 text: "Test comment",
                                 commentable: @library,
                                 user: @user)
    end

    it "it should remove the comment" do
      delete :destroy, id: @comment.id,
                       library_id: @library.id,
                       format: :js

      assert_response :success
    end
  end
end
