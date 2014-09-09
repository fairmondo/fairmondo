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
require_relative '../test_helper'

describe StatisticsController do
  context "as an admin" do
    before { sign_in FactoryGirl.create :admin_user }

    describe "GET 'general'" do
      it "should be successful" do
        get :general
        assert_response :success
      end
    end

    describe "GET 'category_sales'" do
      it "should be successful" do
        get :category_sales
        assert_response :success
      end
    end
  end

  #context "as a random user" do #-- gets tested by policy spec
end
