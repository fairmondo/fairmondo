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

describe ArticlesController do
  let(:user) { FactoryGirl.create(:user) }

   describe "#index" do

    describe "searching" do
      setup do
        TireTest.on
        Article.index.delete
        Article.create_elasticsearch_index
        @vehicle_category = Category.find_by_name!("Fahrzeuge")
        @hardware_category = Category.find_by_name!("Hardware")
        @electronic_category = Category.find_by_name!("Elektronik")
        @software_category = Category.find_by_name!("Software")

        @ngo_article = FactoryGirl.create(:article,price_cents: 1, title: "ngo article thing", content: "super thing", created_at: 4.days.ago)
        @second_hand_article = FactoryGirl.create(:second_hand_article, price_cents: 2, title: "muscheln", categories: [ @vehicle_category ], content: "muscheln am meer", created_at: 3.days.ago)
        @hardware_article = FactoryGirl.create(:second_hand_article,:simple_fair,:simple_ecologic,:simple_small_and_precious,:with_ngo, price_cents: 3, title: "muscheln 2", categories: [ @hardware_category ], content: "abc" , created_at: 2.days.ago)
        @no_second_hand_article = FactoryGirl.create :no_second_hand_article, price_cents: 4, title: "muscheln 3", categories: [ @hardware_category ], content: "cde"
        Article.index.refresh
      end

      teardown do
        TireTest.off
      end

      it "should work with all filters" do
        #should find the article with title 'muscheln' when searching for muscheln
        get :index, article_search_form: {q: "muscheln" }
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.sort.must_equal [@second_hand_article,@hardware_article,@no_second_hand_article].map(&:id).sort

        #should find the article with title 'muscheln' when searching for muschel
        get :index, article_search_form: {q: "muschel" }
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.sort.must_equal [@second_hand_article,@hardware_article,@no_second_hand_article].map(&:id).sort

        #should find the article with content 'meer' when searching for meer
        get :index, article_search_form: {q: "meer" , :search_in_content => "1"}
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.sort.must_equal [@second_hand_article].map(&:id).sort

        #should find the article with price 1 when filtering <= 1
        get :index, article_search_form: { price_to: "0,01" }
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.sort.must_equal [@ngo_article].map(&:id).sort

        #should find the article with price 4 when filtering >= 4
        get :index, article_search_form: { price_from: "0,04" }
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.sort.must_equal [@no_second_hand_article].map(&:id).sort

        #should find the article with price 2 and 3 when filtering >= 2 <= 3
        get :index, article_search_form: { price_to: "0,03" , price_from: "0,02" }
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.sort.must_equal [@second_hand_article,@hardware_article].map(&:id).sort

        #order by price asc
        get :index, article_search_form: { order_by: "cheapest" }
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.must_equal [@ngo_article,@second_hand_article,@hardware_article,@no_second_hand_article].map(&:id)

        #order by newest
        get :index, article_search_form: { order_by: "newest" }
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.must_equal [@no_second_hand_article,@hardware_article,@second_hand_article,@ngo_article].map(&:id)

        # order by condition old
        get :index, article_search_form: { order_by: "old", q: "muscheln" }
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.must_equal [@second_hand_article, @hardware_article, @no_second_hand_article].map(&:id)

        # order by condition new"
        get :index, article_search_form: { order_by: "new", q: "muscheln" }
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.must_equal [@no_second_hand_article, @second_hand_article, @hardware_article].map(&:id)

        # order by fair
        get :index, article_search_form: { order_by: "fair" }
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.must_equal [@hardware_article, @ngo_article, @second_hand_article, @no_second_hand_article].map(&:id)

        # order by ecologic
        get :index, article_search_form: { order_by: "ecologic" }
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.must_equal [@hardware_article, @ngo_article, @second_hand_article, @no_second_hand_article].map(&:id)

        # order by small_and_precious
        get :index, article_search_form: { order_by: "small_and_precious" }
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.must_equal [@hardware_article, @ngo_article, @second_hand_article, @no_second_hand_article].map(&:id)

        # order by price desc
        get :index, article_search_form: { order_by: "most_expensive" }
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.must_equal [@ngo_article, @second_hand_article, @hardware_article, @no_second_hand_article].reverse.map(&:id)

        # order by friendly_percent desc
        get :index, article_search_form: { order_by: "most_donated" }
        @controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.must_equal [@hardware_article, @ngo_article, @second_hand_article, @no_second_hand_article].map(&:id)

        search_params = { article_search_form: { category_id: @hardware_category.id } }
        get :index, search_params
        assert_redirected_to( category_path(@hardware_category.id) )

      end
    end
    describe "for signed-out users" do
      it "should be successful" do
        get :index
        assert_response :success
      end

      it "should render the :index view" do
        get :index
        assert_template(:index)
      end
    end

    describe "for signed-in users" do
      before :each do
        @article = FactoryGirl.create :article
        sign_in user
      end

      it "should be successful" do
        get :index
        assert_template(:index)
      end

    end
  end

  describe "#show" do
    let(:article) { FactoryGirl.create(:article, seller: user) }
    describe "for all users" do

      it "should be successful" do
        article_fair_trust = FactoryGirl.create :fair_trust
        get :show, id: article_fair_trust
        assert_response :success
      end

      it "should be successful" do
        article_social_production = FactoryGirl.create :social_production
        get :show, id: article_social_production
        assert_response :success
      end

      it "should be successful" do
        get :show, id: article
        assert_response :success
      end

      it "should render the :show view" do
        get :show, id: article
        assert_template :show
      end

      it "should render 404 on closed article" do
        article.deactivate
        article.close
        -> { get :show, id: article.id}.must_raise ActiveRecord::RecordNotFound
      end
    end

    describe "for signed-in users" do
      before do
        sign_in user
      end

      it "should be successful" do
        get :show, id: article
        assert_response :success
      end

      it "should render the :show view" do
        get :show, id: article
        assert_template :show
      end

      it "should render a flash message for the owner when it still has a processing image" do
        @controller.expects(:at_least_one_image_processing?).returns true
        get :show, id: article
        flash.now[:notice].must_equal I18n.t('article.notices.image_processing')
      end
    end
  end

  describe "#new" do

    describe "for non-signed-in users" do

      it "should require login" do
        get :new
        assert_redirected_to(new_user_session_path)
      end

    end

    describe "for signed-in users" do

      before :each do
        sign_in user
      end

      it "should render the :new view" do
        get :new
        assert_template :new
      end

      it "should be possible to get a new article from an existing one" do
        @article = FactoryGirl.create :article , :seller => user
        get :new, :edit_as_new => @article.id
        assert_template :new
        @draftarticle= @controller.instance_variable_get(:@article)
        @draftarticle.new_record?.must_equal true
        @draftarticle.title.must_equal(@article.title)
      end

    end
  end

  describe "#edit" do

    describe "for non-signed-in users" do

      it "should deny access" do
        @article = FactoryGirl.create :article
        get :edit, id: @article.id
        assert_redirected_to(new_user_session_path)
      end

    end

    describe "for signed-in users" do

      before :each do
        sign_in user
      end


      it "should be successful for the seller" do
        @article = FactoryGirl.create :preview_article, seller: user
        get :edit, id: @article.id
        assert_template :edit
      end


      it "should not be able to edit other users articles" do
        @article = FactoryGirl.create :preview_article, seller: (FactoryGirl.create(:user))

        -> { get :edit, :id => @article.id }.must_raise Pundit::NotAuthorizedError
      end
    end
  end

  describe "#create" do

    before :each do
      @article_attrs = FactoryGirl.attributes_for :article, category_ids: [FactoryGirl.create(:category).id]
    end

    describe "for non-signed-in users" do
      it "should not create an article" do
        assert_no_difference 'Article.count' do
          post :create, article: @article_attrs
        end
      end
    end

    describe "for signed-in users" do

      before :each do
        sign_in user
      end

      it "should create an article" do
        assert_difference 'Article.count', 1 do
          post :create, article: @article_attrs
        end
      end

      it "should save images even if article is invalid" do
        @article_attrs = FactoryGirl.attributes_for :article, :invalid, categories: [FactoryGirl.create(:category).id]
        @article_attrs[:images_attributes] = { "0" => { :image => fixture_file_upload("/test.png", 'image/png') }}
        assert_difference 'Image.count', 1 do
          post :create, article: @article_attrs
        end
      end

      it "should not raise an error for very high quantity values" do
        post :create, :article => @article_attrs.merge(quantity: "100000000000000000000000")
        assert_template :new
      end

    end
  end

  #TODO: add more tests for delete
  describe "#destroy" do
    describe "for signed-in users" do
      before :each do
        @article = FactoryGirl.create :preview_article, seller: user
        @article_attrs = FactoryGirl.attributes_for :article, categories: [FactoryGirl.create(:category)]
        @article_attrs.delete :seller
        sign_in user
      end

      it "should delete the preview article" do
        assert_difference 'Article.count', -1 do
          put :destroy, :id => @article.id
          assert_redirected_to(user_path(user))
        end
      end

      it "should softdelete the locked article" do
        assert_no_difference 'Article.count' do
          put :update, id: @article.id, :activate => true
          put :update, id: @article.id, :deactivate => true
          put :destroy, :id => @article.id
        end
      end

    end
  end

  describe "#update" do
    describe "for signed-in users" do
      before :each do
        @article = FactoryGirl.create :preview_article, seller: user
        @article_attrs = FactoryGirl.attributes_for :article, categories: [FactoryGirl.create(:category)]
        @article_attrs.delete :seller
        sign_in user
      end

      it "should update the article with new information" do
        put :update, id: @article.id, article: @article_attrs
        assert_redirected_to @article.reload
      end

      it "changes the articles informations" do
        put :update, id: @article.id, article: @article_attrs
        assert_redirected_to @article.reload
        @controller.instance_variable_get(:@article).title.must_equal @article_attrs[:title]
      end
    end

    describe "activate article" do
      before do
        sign_in user
        @article = FactoryGirl.create :preview_article, seller: user
      end

      it "should work" do
        put :update, id: @article.id, :activate => true
        assert_redirected_to @article
        flash[:notice].must_equal I18n.t 'article.notices.create_html'
      end

      it "should work with an invalid article and set it as new article" do
        @article.title = nil
        @article.save validate: false
        ## we now have an invalid record
        put :update, id: @article.id, :activate => true
        assert_redirected_to new_article_path(:edit_as_new => @article.id)
      end
    end

    describe "deactivate article" do
      before do
        sign_in user
        @article = FactoryGirl.create :article, seller: user
      end

      it "should work" do
        put :update, id: @article.id, :deactivate => true
        assert_redirected_to  @article
        flash[:notice].must_equal(I18n.t 'article.notices.deactivated')
      end

      it "should work with an invalid article" do
        @article.title = nil
        @article.save validate: false
        ## we now have an invalid record
         put :update, id: @article.id, :deactivate => true
        assert_redirected_to @article
        @article.reload.locked?.must_equal true
      end

    end

  end

  describe "#autocomplete" do #, search: true

    it "should be successful" do
      TireTest.on
      Article.index.delete
      Article.create_elasticsearch_index
      @article = FactoryGirl.create :article, title: 'chunky bacon'
      Article.index.refresh
      get :autocomplete, q: 'chunky'
      assert_response :success
      response.body.must_equal({ query: 'chunky', suggestions: ['chunky bacon'] }.to_json)
      TireTest.off
    end

    it "should rescue an ECONNREFUSED error" do
      Article.stubs(:search).raises(Errno::ECONNREFUSED)
      get :autocomplete, keywords: 'chunky'
      assert_response :success
      response.body.must_equal [].to_json
    end
  end



end
