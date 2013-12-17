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

describe CategoriesController do
  render_views

  describe "GET 'index" do

    describe "for non-signed-in users" do

      it "should be a guest" do
        controller.should_not be_signed_in
      end

      it "should allow access and show some categories" do
        get :index
        response.should be_success
        # continue checking
      end

      it "should show a category" do
        c = FactoryGirl.create :category
        get :show, :id => c.id, :format => :json
        response.should be_success
        # continue checking
      end

    end

    describe "GET 'id_index'" do
      it "should allow access and show some categories" do
        get :id_index
        response.should be_success
      end
    end


  end
end
