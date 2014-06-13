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
require "test_helper"

describe ArticleTemplatesController do
  describe "routing" do

    it "routes to #new" do
      get("/article_templates/new").should route_to("article_templates#new")
    end

    it "routes to #edit" do
      get("/article_templates/1/edit").should route_to("article_templates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/article_templates").should route_to("article_templates#create")
    end

    it "routes to #update" do
      put("/article_templates/1").should route_to("article_templates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/article_templates/1").should route_to("article_templates#destroy", :id => "1")
    end

  end
end
