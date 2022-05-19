#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class StatisticsControllerTest < ActionController::TestCase
  before { sign_in(create :admin_user) }

  describe "GET 'general'" do
    it 'should be successful' do
      get :general
      assert_response :success
    end
  end

  describe "GET 'category_sales'" do
    it 'should be successful' do
      get :category_sales
      assert_response :success
    end
  end
end
