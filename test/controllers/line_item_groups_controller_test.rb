#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class LineItemGroupsControllerTest < ActionController::TestCase
  let(:lig) { create :line_item_group, :sold, :with_business_transactions, traits: [:paypal, :transport_type1] }
  let(:buyer) { lig.buyer }

  before do
    sign_in buyer
  end

  describe "GET 'show'" do
    it 'should show a success flash when redirected after paypal success' do
      get :show, params: { id: lig.id, paid: 'true' }
      flash[:notice].must_equal I18n.t('line_item_group.notices.paypal_success')
    end

    it 'should show an error flash when redirected after paypal cancellation' do
      get :show, params: { id: lig.id, paid: 'false' }
      flash[:error].must_equal I18n.t('line_item_group.notices.paypal_cancel')
    end
  end
end
