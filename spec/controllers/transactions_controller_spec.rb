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
require 'spec_helper'

describe TransactionsController do
  render_views


  # This controller test only tests things that should not be reached by a user
  # Find the feature test in spec/features/transaction_spec.rb for all other transaction related test cases

  describe "PUT 'update" do

    describe "for signed-in users" do
      before :each do
         @user = FactoryGirl.create(:user)
         sign_in @user
      end

      it "should render 'edit' if we get false transaction attributes" do
        @transaction = FactoryGirl.create :single_transaction
        @transaction_attributes = FactoryGirl.attributes_for :single_transaction, :incomplete
        put :update, id: @transaction.id, transaction: @transaction_attributes
        response.should render_template("edit")
      end

      it "should not be possible to buy nothing and still have a transaction filled" do
        @transaction = FactoryGirl.create :multiple_transaction
        @transaction_attributes = FactoryGirl.attributes_for :multiple_transaction, :bought_nothing
        put :update, id: @transaction.id, transaction: @transaction_attributes
        response.should render_template("edit")
      end

    end
  end
end
