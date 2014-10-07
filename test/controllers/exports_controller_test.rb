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

describe ExportsController do

  describe "mass-upload creation" do
    before do
      @user = FactoryGirl.create :legal_entity, :paypal_data
      FactoryGirl.create :article, seller: @user
      FactoryGirl.create :line_item_group, :with_business_transactions, :sold, seller: @user
      sign_in @user
    end

    describe "GET 'show'" do
      it "should be successful" do
        time = Time.now
        Time.stubs(:now).returns(time)
        get :show, :kind_of_article => "active", :format => "csv"
        response.content_type.must_equal("text/csv; charset=utf-8")
        response.headers["Content-Disposition"].must_equal("attachment; filename=\"Fairmondo_export_#{time.strftime("%Y-%d-%m %H:%M:%S")}.csv\"")
        assert_response :success
      end
    end

#    describe "GET 'show'" do
#      it "should be successful" do
#        time = Time.now
#        Time.stubs(:now).returns(time)
#        get :show, :kind_of_article => "seller_line_item_groups", :format => "csv"
#        response.content_type.must_equal("text/csv; charset=utf-8")
#        response.headers["Content-Disposition"].must_equal("attachment; filename=\"Fairmondo_purchase_export_#{time.strftime("%Y-%d-%m %H:%M:%S")}.csv\"")
#        assert_response :success
#      end
#    end
#
#    describe "GET 'show' with time range" do
#      it "should be successful" do
#        time = Time.now
#        Time.stubs(:now).returns(time)
#        get :show, :kind_of_article => "seller_line_item_groups", :format => "csv", :time_range => 3
#        response.content_type.must_equal("text/csv; charset=utf-8")
#        response.headers["Content-Disposition"].must_equal("attachment; filename=\"Fairmondo_purchase_export_#{time.strftime("%Y-%d-%m %H:%M:%S")}.csv\"")
#        assert_response :success
#      end
#    end

  end
end
