#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
require_relative '../test_helper'

describe UsersController do

  describe "GET 'show'" do

    describe "for non-signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
      end

      it "should be successful" do
        get :show , :id => @user
        assert_response :success
      end

      it "render deleted user for banned users" do
        @user.update_attribute(:banned,true)
        get :show , :id => @user
        assert_response :success
        assert_template :user_deleted
      end

    end

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end


      it "should be successful" do
        get :show, :id => @user
        assert_response :success
      end
    end
  end

  describe "GET 'profile'" do
      before :each do
        @user = FactoryGirl.create(:legal_entity)
      end

      it "should be successful" do
        get :profile , id: @user, format: :pdf, print: 'terms'
        assert_response :success
      end
  end

  describe "GET contact" do
    let(:user) { FactoryGirl.create :user }

    it 'should be successful' do
      xhr :get, :contact, id: user.id
      assert_response :success
      assert_template :contact
    end
  end
end
