#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class BusinessTransactionsControllerTest < ActionController::TestCase
  def login
    user = create(:legal_entity)
    sign_in user
    user
  end

  describe 'GET show' do
    it 'should redirect to line item group' do
      bt = create :business_transaction
      sign_in bt.seller
      get :show, params:{ id: bt.id }
      assert_redirected_to line_item_group_path(bt.line_item_group)
    end
  end

  describe 'GET set_transport_ready' do
    it 'should redirect to line item group with success notice' do
      bt = create :business_transaction
      sign_in bt.seller
      get :set_transport_ready, params:{ id: bt.id }
      assert_redirected_to line_item_group_path(bt.line_item_group)
      assert_equal I18n.t('transaction.notice.ready_success'), assigns[:notice]
    end

    it 'should redirect with failure notice if bt is already shipped' do
      bt = create :business_transaction
      bt.ship
      sign_in bt.seller
      get :set_transport_ready, params:{ id: bt.id }
      assert_redirected_to line_item_group_path(bt.line_item_group)
      assert_equal I18n.t('transaction.notice.ready_failure'), assigns[:notice]
    end
  end

  describe 'GET export' do
    it 'should redirect if not logged in' do
      get :export, params:{ date: { year: 2016, month: 3 } }
      assert_response(:redirect)
    end

    it 'should be successful if logged in' do
      login
      get :export, params:{ date: { year: 2016, month: 3 } }
      assert_response(:success)
    end

    it 'should the current user' do
      user = login
      get :export, params:{ date: { year: 2016, month: 3 } }
      assigns(:user).must_equal(user)
    end

    it 'should assign the correct time_range' do
      login
      get :export, params:{ date: { year: 2016, month: 3 } }
      assigns(:time_range).must_equal(
        (DateTime.new(2016, 3, 1).beginning_of_day)..(DateTime.new(2016, 3, 31).end_of_day)
      )
    end
  end
end
