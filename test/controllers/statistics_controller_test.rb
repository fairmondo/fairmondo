#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe StatisticsController do
  let(:admin_user) { FactoryGirl.create :admin_user }

  context 'as an admin' do
    before do
      sign_in admin_user
    end

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

  # context "as a random user" do #-- gets tested by policy spec
end
