#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
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
      let(:user) { create :user }

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
