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
    end

    describe "GET 'id_index'" do
      it "should allow access and show some categories" do
        get :id_index
        response.should be_success
      end
    end
  end

  describe "GET 'show'" do
    it "should show a category when format is html" do
      get :show, id: FactoryGirl.create(:category).id
      response.should be_success
    end

    it "should show a category when format is json" do
      get :show, id: FactoryGirl.create(:category).id, format: :json
      response.should be_success
    end

    it "should rescue an ECONNREFUSED error" do
      Article.any_instance.stub(:search).and_raise(Errno::ECONNREFUSED)
      get :show, id: FactoryGirl.create(:category).id, article_search_form: { q: 'foobar' }
      response.status.should be 200
    end

    describe "search", search: true, setup: true do
      before(:all) do
        setup
        @electronic_category = Category.find_by_name!("Elektronik")
        @hardware_category = Category.find_by_name!("Hardware")
        @software_category = Category.find_by_name!("Software")

        @ngo_article = FactoryGirl.create(:article,price_cents: 1, title: "ngo article thing", content: "super thing", created_at: 4.days.ago)
        @second_hand_article = FactoryGirl.create(:second_hand_article, price_cents: 2, title: "muscheln", categories: [ @software_category ], content: "muscheln am meer", created_at: 3.days.ago)
        @hardware_article = FactoryGirl.create(:second_hand_article,:simple_fair,:simple_ecologic,:simple_small_and_precious,:with_ngo, price_cents: 3, title: "muscheln 2", categories: [ @hardware_category ], content: "abc" , created_at: 2.days.ago)
        @no_second_hand_article = FactoryGirl.create :no_second_hand_article, price_cents: 4, title: "muscheln 3", categories: [ @hardware_category ], content: "cde"
        Article.index.refresh
      end


      it "should find the article in category 'Hardware' when filtering for 'Hardware'" do
        get :show, id: @hardware_category.id
        controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should =~ [@hardware_article,@no_second_hand_article].map(&:id)
      end

      it "should find the article in category 'Hardware' when filtering for the ancestor 'Elektronik'" do
        get :show, id: @electronic_category.id
        controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should =~ [@second_hand_article,@hardware_article,@no_second_hand_article].map(&:id)
      end

      it "should ignore the category_id field and always search in the given category" do
        get :show, id: @hardware_category.id, article_search_form: { category_id: @software_category.id }
        controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should == [@no_second_hand_article,@hardware_article].map(&:id)
      end

      context "and searching for 'muscheln'" do
        it "should chain both filters" do
          get :show, id: @hardware_category.id, article_search_form: { q: "muscheln" }
          controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should =~ [@hardware_article,@no_second_hand_article].map(&:id)
        end

        context "and filtering for condition" do
          it "should chain all filters" do
            get :show, id: @hardware_category.id, article_search_form: { q: "muscheln", condition: :old }
            controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should == [@hardware_article].map(&:id)
          end
        end
      end
    end
  end
end
