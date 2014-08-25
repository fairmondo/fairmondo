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
require_relative "../test_helper"

describe HeartsController do

  describe "POST Heart on libraries" do
    describe "for non-signed-in users" do
      before :each do
        @library = FactoryGirl.create(:library)
        @library_2 = FactoryGirl.create(:library)
      end

      it "should allow posting using ajax" do
        post :create, library_id: @library.id, format: :js
        assert_response :success
      end

      it "change the heart count when posting" do
        assert_difference "@library.hearts_count", 1 do
          post :create, library_id: @library.id, format: :js
        end
      end

      it "adds maximally one heart even when posting multiple times" do
        assert_difference "@library.hearts_count", 1 do
          3.times { post :create, library_id: @library.id, format: :js }
        end
      end

      it "should allow hearting a second library" do
        assert_difference "@library_2.hearts_count", 1 do
          post :create, library_id: @library.id, format: :js
          post :create, library_id: @library_2.id, format: :js
        end
      end
    end

    describe "for signed-in users" do
      before :each do
        @library = FactoryGirl.create(:library)
        @library_2 = FactoryGirl.create(:library)
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "should allow posting using ajax" do
        post :create, library_id: @library.id, format: :js
        assert_response :success
      end

      it "increases the heart count when posting" do
        assert_difference "@library.hearts_count", 1 do
          post :create, library_id: @library.id, format: :js
        end
      end

      it "adds maximally one heart even when posting multiple times" do
        assert_difference "@library.hearts_count", 1 do
          3.times { post :create, library_id: @library.id, format: :js }
        end
      end

      it "should allow hearting a second library" do
        assert_difference "@library_2.hearts_count", 1 do
          post :create, library_id: @library.id, format: :js
          post :create, library_id: @library_2.id, format: :js
        end
      end
    end
  end
  describe "DELETE Heart on libraries" do
    describe "for non-signed-in users" do
      before :each do
        @library = FactoryGirl.create(:library)
        @user = FactoryGirl.create(:user)
        @owned_heart = @library.hearts.create(heartable: @library, user: @user)
        @anonymous_heart = @library.hearts.create(heartable: @library,
              user_token: "RandomUserTokenThiswouldActuallyBeRandomData")
      end

      it "will not delete an owned heart" do
        assert_difference "@library.hearts_count", 0 do
          delete :destroy, library_id: @library.id, id: @owned_heart.id
        end
      end

      it "will not delete an anonymous heart" do
        assert_difference "@library.hearts_count", 0 do
          delete :destroy, library_id: @library.id, id: @anonymous_heart.id
        end
      end
    end

    describe "for signed-in users" do
      before :each do
        @library = FactoryGirl.create(:library)
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "will delete his own heart" do
        @owned_heart = @library.hearts.create(heartable: @library, user: @user)
        assert_difference "@library.hearts_count", -1 do
          delete :destroy, library_id: @library.id,
            id: @owned_heart.id, format: :js
        end
      end

      it "will not delete an anonymous heart" do
        @anonymous_heart = @library.hearts.create(heartable: @library,
          user_token: "RandomUserTokenThiswouldActuallyBeRandomData")
        assert_raises Pundit::NotAuthorizedError do
          delete :destroy, library_id: @library.id,
            id: @anonymous_heart.id, format: :js
        end
      end

      it "will not delete someone else's heart" do
        @another_user = FactoryGirl.create(:user)
        @another_users_heart = @library.hearts.create(heartable: @library,
                                                      user: @another_user)
        assert_raises Pundit::NotAuthorizedError do
          delete :destroy, library_id: @library.id,
            id: @another_users_heart.id, format: :js
        end
      end

    end
  end
end
