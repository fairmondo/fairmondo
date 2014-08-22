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
require_relative '../test_helper'

describe LibrariesController do

  describe "GET 'index" do
    describe "for non-signed-in users" do
      before :each do
        @user = FactoryGirl.create(:user)
      end

      it "should allow access" do
        get :index, :user_id => @user.id
        assert_response :success
      end
    end

    describe "for signed-in users" do
      before :each do
        @library = FactoryGirl.create(:library)

        sign_in @library.user
      end

      it "should be successful" do
        get :index, :user_id => @library.user
        assert_response :success
      end

      it "should be successful" do
        get :show, :user_id => @library.user, :id => @library.id
        assert_response :success
      end
    end

    describe '::focus' do
      it 'should return Library if no user is focused' do
        @controller.stubs(:user_focused?).returns(false)
        assert_equal(Library, @controller.send(:focus))
      end
    end
  end

  describe '#create' do
    it 'should return a library with auditing disabled' do
    end
  end

  describe "#update" do
    it 'should disable auditing for welcome page' do
    end
  end

  describe '#admin_audit' do
    before :each do
      @library = FactoryGirl.create(:library)
    end

    it 'should toggle library audit status via ajax' do
      user = FactoryGirl.create(:admin_user)
      sign_in user

      # audited should be false when library is created...
      assert_equal(@library.audited, false)

      # ...true after first request...
      xhr :patch, :admin_audit, id: @library.id
      @library = Library.find(@library.id);
      assert_equal(@library.audited, true)
      assert_response :success

      # ...false after second request.
      xhr :patch, :admin_audit, id: @library.id
      @library = Library.find(@library.id);
      assert_equal(@library.audited, false)
      assert_response :success
    end
  end

end
