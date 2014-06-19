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

describe CategoriesController do
  let(:category) { FactoryGirl.create(:category) }

  describe "GET ::index" do
    describe "for non-signed-in users" do

      it "should allow access and show some categories" do
        get :index
        assert_response :success
      end
    end

    describe "GET 'id_index'" do
      it "should allow access and show some categories" do
        get :id_index
        assert_response :success
      end
    end
  end

  describe 'GET select_category' do
    it 'should allow to select a category' do
      get :select_category, id: category.id, object_name: 'article'
      assert_response :success
    end
  end

  describe "GET 'show'" do
    it "should show a category when format is html" do
      get :show, id: category.id
      assert_response :success
    end

    it "should show a category when format is json" do
      get :show, id: category.id, format: :json
      assert_response :success
    end

    it "should rescue an ECONNREFUSED error" do
      Article.any_instance.stubs(:search).raises(Errno::ECONNREFUSED)
      get :show, id: category.id, article_search_form: { q: 'foobar' }
      assert_response :success
    end

    describe "search" do
      setup do
        TireTest.on
        @electronic_category = Category.find_by_name!("Elektronik")
        @hardware_category = Category.find_by_name!("Hardware")
        @software_category = Category.find_by_name!("Software")

        @ngo_article = FactoryGirl.create(:article, price_cents: 1, title: "ngo article thing", content: "super thing", created_at: 4.days.ago)
        @second_hand_article = FactoryGirl.create(:second_hand_article, price_cents: 2, title: "muscheln", categories: [ @software_category ], content: "muscheln am meer", created_at: 3.days.ago)
        @hardware_article = FactoryGirl.create(:second_hand_article,:simple_fair,:simple_ecologic,:simple_small_and_precious,:with_ngo, price_cents: 3, title: "muscheln 2", categories: [ @hardware_category ], content: "abc" , created_at: 2.days.ago)
        @no_second_hand_article = FactoryGirl.create :no_second_hand_article, price_cents: 4, title: "muscheln 3", categories: [ @hardware_category ], content: "cde"
        Article.index.refresh
      end
      teardown do
        TireTest.off
      end

      it "should find the article in category 'Hardware' when filtering for 'Hardware'" do
        get :show, id: @hardware_category.id
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.must_equal [@no_second_hand_article,@hardware_article].map(&:id)
      end

      it "should find the article in category 'Hardware' when filtering for the ancestor 'Elektronik'" do
        get :show, id: @electronic_category.id
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.must_equal [@no_second_hand_article,@hardware_article,@second_hand_article].map(&:id)
      end

      it "should ignore the category_id field and always search in the given category" do
        get :show, id: @hardware_category.id, article_search_form: { category_id: @software_category.id }
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.must_equal [@no_second_hand_article,@hardware_article].map(&:id)
      end

      context "and searching for 'muscheln'" do
        it "should chain both filters" do
          get :show, id: @hardware_category.id, article_search_form: { q: "muscheln" }
          @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.must_equal [@no_second_hand_article,@hardware_article].map(&:id)
        end

        context "and filtering for condition" do
          it "should chain all filters" do
            get :show, id: @hardware_category.id, article_search_form: { q: "muscheln", condition: :old }
            @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.must_equal [@hardware_article].map(&:id)
          end
        end
      end
    end
  end
end
