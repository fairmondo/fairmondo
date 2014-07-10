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

describe RegistrationsController do

  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "user-management" do
    describe "for non-signed-in users" do
      before :each do
        @user = FactoryGirl.create(:user)
      end

      it "should deny access" do
        get :edit
        assert_redirected_to(new_user_session_path)
      end

    end

    describe "for signed-in users" do
      before :each do
        @user = FactoryGirl.create(:user)

        sign_in @user
      end

      it "should be successful" do
        get :edit
        assert_response :success
      end

      it "should sucessfully update a user" do
        @attr = { about_me: 'Ich bin eine Profilbeschreibung', email: @user.email }

        put :update, user: @attr

        assert_redirected_to @user.reload
        @controller.instance_variable_get(:@user).about_me.must_equal @attr[:about_me]
      end
    end
  end

  describe "#create" do
    before(:each) do
      @valid_params = {
        user: {
          nickname: "johndoe",
          email:    "jdoe@example.com",
          password: "password",
          password_confirmation: "password",
          legal:    "1",
          agecheck: "1",
          type:     "PrivateUser"
        }
      }
    end
  end

  describe "#update" do
    it "should still try to save the image on failed update" do
      user = FactoryGirl.create(:user)
      sign_in user
      Image.any_instance.expects(:save)
      put :update, user: {nickname: user.nickname, image_attributes: {}, address: {}} # invalid params
    end
  end
end
