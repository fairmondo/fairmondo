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

describe SessionsController do
  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "GET 'layout'" do
    context 'when format is html' do
      it 'should use application layout' do
        get :new
        assert_template layout: true
      end
    end

    context 'when format is AJAX' do
      context 'and the user is logged out' do
        it 'should use no layout' do
          xhr :get, :new
          assert_template layout: false
        end
      end

      context 'and the user is logged in' do
        let(:user) { FactoryGirl.create :user }
        before { sign_in user, false }

        it 'should render the reload site' do
          xhr :get, :new, format: 'html'
          assert_redirected_to toolbox_reload_path
        end
      end
    end
  end

  describe "POST 'create'" do
    before do
      @user = FactoryGirl.create :user, email: 'cookie@test.de'
      @cart = FactoryGirl.create(:cart, user: nil)
      cookies.signed[:cart] = @cart.id
    end

    it 'should set the user_id of an existing cart cookie' do
      post :create, user: { email: @user.email, password: 'password' }
      @cart.reload.user.must_equal @user
    end

    it 'should save belboon tracking token in user if session has token' do
      session[:belboon] = 'abcd,1234'
      post :create, user: { email: @user.email, password: 'password' }
      @user.reload.belboon_tracking_token.must_equal 'abcd,1234'
      session[:belboon].must_equal nil
    end
  end

  describe "DELETE 'destroy'" do
    before do
      @user = FactoryGirl.create :user,
                                 belboon_tracking_token: 'abcd,1234',
                                 belboon_tracking_token_set_at: 9.days.ago
      sign_in @user
      cookies.signed[:cart] = 1
    end

    it 'should delete the cart cookie' do
      get :destroy
      cookies.signed[:cart].must_equal nil
    end

    it 'should delete belboon tracking token, when void' do
      get :destroy
      @user.reload.belboon_tracking_token.must_equal nil
      @user.reload.belboon_tracking_token_set_at.must_equal nil
    end
  end
end
