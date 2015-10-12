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

describe WelcomeController do
  describe "GET 'index" do
    describe 'for non-signed-in users' do
      it 'should be successful' do
        get :index
        assert_response :success
      end

      it 'should set all instance variables except one' do
        get :index
        refute_nil assigns(:queue1)
        refute_nil assigns(:queue2)
        refute_nil assigns(:donation_articles)
        refute_nil assigns(:trending_libraries)
        assert_nil assigns(:last_hearted_libraries)
      end
    end

    describe 'for signed-in users' do
      let(:user) { FactoryGirl.create :user }

      it 'should set all instance variables' do
        sign_in user
        get :index
        refute_nil assigns(:queue1)
        refute_nil assigns(:queue2)
        refute_nil assigns(:donation_articles)
        refute_nil assigns(:trending_libraries)
        refute_nil assigns(:last_hearted_libraries)
      end
    end
  end

  describe "GET 'feed'" do
    describe 'for non-signed-in users' do
      it 'should be successful' do
        get :feed, format: 'rss'
        assert_response :success
        response.content_type.must_equal('application/rss+xml')
      end
    end
  end
end
