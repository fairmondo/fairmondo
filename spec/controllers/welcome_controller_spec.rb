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

describe WelcomeController do
  render_views

  describe "GET 'index" do

    describe "for non-signed-in users" do

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should be successful" do
        get :landing
        response.should be_success
      end

      it "should be successful" do
        get :feed, :format => "rss"
        response.should be_success
        response.content_type.should eq("application/rss+xml")
      end

    end
  end
end
