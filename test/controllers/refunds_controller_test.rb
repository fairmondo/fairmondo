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

include FastBillStubber

describe RefundsController do
  let( :seller ){ FactoryGirl.create :user }
  let( :line_item_group) { FactoryGirl.create :line_item_group, seller: seller}
  let( :business_transaction ){ FactoryGirl.create :business_transaction, :old, line_item_group: line_item_group }

  describe '#create' do
    describe 'for signed in users' do
      it 'should create refund request' do
        @refund_attrs = FactoryGirl.attributes_for :refund
        sign_in seller
        assert_difference 'Refund.count', 1 do
          post :create, refund: @refund_attrs, business_transaction_id: business_transaction.id
        end
      end
    end
  end

  describe '#new' do
    describe 'for signed in users' do
      it 'should render "new" view ' do
        sign_in seller
        get :new, user_id: seller.id, business_transaction_id: business_transaction.id
        assert_response :success
      end
    end
  end
end
