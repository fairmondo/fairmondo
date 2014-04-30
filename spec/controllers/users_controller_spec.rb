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
require 'spec_helper'

describe UsersController do

  render_views

  describe "GET 'show'" do

    describe "for non-signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
      end

      it "should be a guest" do
        controller.should_not be_signed_in
      end

      it "should be successful" do
        get :show , :id => @user
        response.should be_success
      end
    end

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)

        sign_in @user
      end

      it "should be logged in" do
        controller.should be_signed_in
      end

      it "should be successful" do
        get :show, :id => @user
        response.should be_success
      end
    end
  end

  describe "sign in" do
    it "should be sucessful" do
      get :login
      response.should be_success
    end
  end


#  describe "community" do
#
#    describe "for non-signed-in users" do
#
#      it "should deny access" do
#        get :community
#        response.should redirect_to(new_user_session_path)
#      end
#    end

#    describe "for signed-in users" do
#
#      before :each do
#        @user = FactoryGirl.create(:user)
#        sign_in @user
#      end

#      it "should be successful" do
#        get :community
#        response.should be_success
#      end
#    end
#  end

#  describe "search_users" do
#
#    describe "for non-signed-in users" do
#
#      it "should deny access" do
#        get :search_users
#        response.should redirect_to(new_user_session_path)
#      end
#    end
#
#    describe "for signed-in users" do
#
#      before :each do
#        @user = FactoryGirl.create(:user)
#        sign_in @user
#      end
#
#      it "should be successful" do
#        get :search_users
#        response.should be_success
#      end
#
#
#    end
#  end

# describe "list_followers" do
#
#    describe "for non-signed-in users" do
#
#      it "should deny access" do
#        get :list_followers
#        response.should redirect_to(new_user_session_path)
#      end
#    end
#
#    describe "for signed-in users" do
#
#      before :each do
#        @user = FactoryGirl.create(:user)
#        sign_in @user
#      end
#
#      it "should be successful" do
#        get :list_followers
#        response.should be_success
#      end
#    end
#  end

#  describe "list_following" do
#
#    describe "for non-signed-in users" do
#
#      it "should deny access" do
#        get :list_following
#        response.should redirect_to(new_user_session_path)
#      end
#    end
#
#    describe "for signed-in users" do
#
#      before :each do
#        @user = FactoryGirl.create(:user)
#        sign_in @user
#      end
#
  #TODO
  #   it "should be successful" do
  #      get :list_following
  #      response.should be_success
  #    end
#    end
#  end

#  describe "follow" do
#
#    describe "for non-signed-in users" do
#
#      it "should deny access" do
#        get :follow
#        response.should redirect_to(new_user_session_path)
#      end
#    end
#
#    describe "for signed-in users" do
#
#      before :each do
#        @user = FactoryGirl.create(:user)
#        sign_in @user
#      end

#      it "should be successful" do
#        get :follow, :id => @user
#        response.should have_content("#")
#      end
#    end
#  end

#  describe "stop_follow" do
#
#    describe "for non-signed-in users" do
#
#      it "should deny access" do
#        get :stop_follow
#        response.should redirect_to(new_user_session_path)
#      end
#    end

#    describe "for signed-in users" do
#
#      before :each do
#        @user = FactoryGirl.create(:user)
#        sign_in @user
#      end

#      it "should be successful" do
#        get :stop_follow, :id => @user
#        response.should have_content("#")
#      end
#    end
#  end

end
