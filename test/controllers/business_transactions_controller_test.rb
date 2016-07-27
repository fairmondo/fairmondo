#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe BusinessTransactionsController do
  def login
    user = create(:legal_entity)
    sign_in user
    user
  end

  describe 'GET export' do
    it 'should redirect if not logged in' do
      get :export, date: { year: 2016, month: 3 }
      assert_response(302)
    end

    it 'should be successful if logged in' do
      login
      get :export, date: { year: 2016, month: 3 }
      assert_response(200)
    end

    it 'should the current user' do
      user = login
      get :export, date: { year: 2016, month: 3 }
      assigns(:user).must_equal(user)
    end

    it 'should assign the correct time_range' do
      login
      get :export, date: { year: 2016, month: 3 }
      assigns(:time_range).must_equal(
        (DateTime.new(2016, 3, 1).beginning_of_day)..(DateTime.new(2016, 3, 31).end_of_day)
      )
    end
  end

end
