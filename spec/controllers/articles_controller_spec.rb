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

describe ArticlesController do
  render_views

  let(:user) { FactoryGirl.create(:user) }
  let(:article) { FactoryGirl.create(:article, seller: user) }


   describe "GET 'index'" do

    describe "search", :search => true, :setup => true do
      before(:all) do
        setup
        @vehicle_category = Category.find_by_name!("Fahrzeuge")
        @hardware_category = Category.find_by_name!("Hardware")
        @electronic_category = Category.find_by_name!("Elektronik")
        @software_category = Category.find_by_name!("Software")

        @ngo_article = FactoryGirl.create(:article,price_cents: 1, title: "ngo article thing", content: "super thing")
        @second_hand_article = FactoryGirl.create(:second_hand_article, price_cents: 2, title: "muscheln", categories_and_ancestors: [ @vehicle_category ], content: "muscheln am meer")
        @hardware_article = FactoryGirl.create(:second_hand_article,:with_ngo, price_cents: 3, title: "muscheln 2", categories_and_ancestors: [ @hardware_category ], content: "abc")
        @no_second_hand_article = FactoryGirl.create :no_second_hand_article, price_cents: 4, title: "muscheln 3", categories_and_ancestors: [ @hardware_category ], content: "cde"
        Article.index.refresh
      end



      it "should find the article with title 'muscheln' when searching for muscheln" do
        get :index, :article => {:title => "muscheln" }
        controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should =~ [@second_hand_article,@hardware_article,@no_second_hand_article].map(&:id)
      end

      it "should find the article with title 'muscheln' when searching for muschel" do
        get :index, :article => {:title => "muschel" }
        controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should =~ [@second_hand_article,@hardware_article,@no_second_hand_article].map(&:id)
      end

      it "should find the article with content 'meer' when searching for meer" do
       get :index, :article => {:title => "meer" , :search_in_content => "1"}
       controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should == [@second_hand_article].map(&:id)
      end

      context "when trying a different search order" do

        it "order by price asc" do
          get :index, :article => {:search_order_by => "cheapest"}
          controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should == [@ngo_article,@second_hand_article,@hardware_article,@no_second_hand_article].map(&:id)
        end

        it "order by price desc" do
          get :index, :article => {:search_order_by => "most_expensive"}
          controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should == [@ngo_article,@second_hand_article,@hardware_article,@no_second_hand_article].reverse.map(&:id)
        end

        it "order by friendly_percent desc" do
           get :index, :article => {:search_order_by => "most_donated",:categories_and_ancestors => [@hardware_category]}
           controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should == [@hardware_article,@no_second_hand_article].map(&:id)
        end

      end

      context "when filtering by categories" do

        it "should find the article in category 'Hardware' when filtering for 'Hardware'" do
          get :index, :article => {:categories_and_ancestors => [@hardware_category] }
          controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should =~ [@hardware_article,@no_second_hand_article].map(&:id)
        end

        it "should find the article in category 'Hardware' when filtering for the ancestor 'Elektronik'" do
          get :index, :article => {:categories_and_ancestors => [@electronic_category] }
          controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should =~ [@hardware_article,@no_second_hand_article].map(&:id)
        end

        it "should not find the article in category 'Hardware' when filtering for 'Software'" do
          get :index, :article => {:categories_and_ancestors => [@software_category] }
          controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should == []
        end

        context "and searching for 'muscheln'" do

          it "should find all articles with title 'muscheln' with an empty categories filter" do
            get :index, :article => {:categories_and_ancestors => [], :title => "muscheln"}
            controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should =~ [@no_second_hand_article,@hardware_article,@second_hand_article].map(&:id)
          end

          it "should chain both filters" do
            get :index, :article => {:categories_and_ancestors => [ @hardware_category ], :title => "muscheln"}
            controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should =~ [@hardware_article,@no_second_hand_article].map(&:id)
          end

          context "and filtering for condition" do

            it "should chain all filters" do
              get :index, article: {categories_and_ancestors: [ @hardware_category ], title: "muscheln", condition: "old"}
              controller.instance_variable_get(:@articles).map{|a| a.id.to_i }.should == [@hardware_article].map(&:id)
            end

          end

        end

      end

    end
    describe "for signed-out users" do
      it "should be successful" do
        get :index
        response.should be_successful
      end

      it "should render the :index view" do
        get :index
        response.should render_template :index
      end
    end

    describe "for signed-in users" do
      before :each do
        @article = FactoryGirl.create :article
        sign_in user
      end

      it "should be successful" do
        get :index
        response.should render_template :index
      end

      it "should render the :index view" do
        get :index
        response.should render_template :index
      end

      it "should be successful" do
        get :index, condition: "true"
        response.should be_success
      end

      it "should be successful" do
        get :index, selected_category_id: Category.all.sample.id
        response.should be_success
      end

      it "should be successful" do
        get :index, article: {:title => "true" }
        response.should be_success
      end
    end
  end

  describe "GET 'show" do

    describe "for all users" do

      it "should be successful" do
        article_fair_trust = FactoryGirl.create :fair_trust
        get :show, id: article_fair_trust
        response.should be_success
      end

      it "should be successful" do
        article_social_production = FactoryGirl.create :social_production
        get :show, id: article_social_production
        response.should be_success
      end

      it "should be successful" do
        get :show, id: article
        response.should be_success
      end

      it "should render the :show view" do
        get :show, id: article
        response.should render_template :show
      end

      it "should render 404 on closed article" do
        article.deactivate
        article.close
        expect { get :show, id: article}.to raise_error ActiveRecord::RecordNotFound

      end

    end

    describe "for signed-in users" do
      before do
        sign_in user
      end

      it "should be successful" do
        get :show, id: article
        response.should be_success
      end

      it "should render the :show view" do
        get :show, id: article
        response.should render_template :show
      end

      it "should render a flash message for the owner when it still has a processing image" do
        ArticlesController.any_instance.should_receive(:at_least_one_image_processing?).and_return true
        get :show, id: article
        flash.now[:notice].should eq I18n.t('article.notices.image_processing')
      end
    end
  end

  describe "GET 'new'" do

    describe "for non-signed-in users" do

      it "should require login" do
        get :new
        response.should redirect_to(new_user_session_path)
      end

    end

    describe "for signed-in users" do

      before :each do
        sign_in user
      end

      it "should render the :new view" do
        get :new
        response.should render_template :new
      end

      it "should be possible to get a new article from an existing one" do
        @article = FactoryGirl.create :article, :without_image , :seller => user
        get :new, :edit_as_new => @article.id
        response.should render_template :new
        @draftarticle= controller.instance_variable_get(:@article)
        @draftarticle.new_record?.should be true
        expect(@draftarticle.title).to eq(@article.title)
      end

    end
  end

  describe "GET 'edit'" do

    describe "for non-signed-in users" do

      it "should deny access" do
        @article = FactoryGirl.create :article
        get :edit, id: @article.id
        response.should redirect_to new_user_session_path
      end

    end

    describe "for signed-in users" do

      before :each do
        sign_in user
      end

      context 'his articles' do
        before :each do
          @article = FactoryGirl.create :preview_article, seller: user
        end

        it "should be successful for the seller" do
          get :edit, id: @article.id
          response.should be_success
        end
      end

      it "should not be able to edit other users articles" do
        @article = FactoryGirl.create :preview_article

        expect do
          get :edit, :id => @article
        end.to raise_error ActiveRecord::RecordNotFound # fails before pundit because of method chain
      end
    end
  end



  describe "POST 'create'" do

    before :each do
      @article_attrs = FactoryGirl.attributes_for :article, categories_and_ancestors: [FactoryGirl.create(:category).id]
    end

    describe "for non-signed-in users" do
      it "should not create an article" do
        lambda do
          post :create, article: @article_attrs
        end.should_not change(Article, :count)
      end
    end

    describe "for signed-in users" do

      before :each do
        sign_in user
      end

      it "should create an article" do
        lambda do
          post :create, article: @article_attrs
        end.should change(Article.unscoped, :count).by 1
      end

      it "should save images even if article is invalid" do
        @article_attrs = FactoryGirl.attributes_for :article, :invalid, categories_and_ancestors: [FactoryGirl.create(:category).id]
        @article_attrs[:images_attributes] = { "0" => { :image => fixture_file_upload("/test.png", 'image/png') }}
        lambda do
          post :create, article: @article_attrs
        end.should change(Image.unscoped, :count).by 1
      end

      it "should not raise an error for very high quantity values" do
        post :create, :article => @article_attrs.merge(quantity: "100000000000000000000000")
        response.should render_template :new
        response.response_code.should == 200
      end

    end
  end

  #TODO: add more tests for delete
  describe "PUT 'destroy'" do
    describe "for signed-in users" do
      before :each do
        @article = FactoryGirl.create :preview_article, seller: user
        @article_attrs = FactoryGirl.attributes_for :article, categories_and_ancestors: [FactoryGirl.create(:category)]
        @article_attrs.delete :seller
        sign_in user
      end

      it "should delete the preview article" do
        lambda do
          put :destroy, :id => @article.id
          response.should redirect_to(user_path(user))
        end.should change(Article.unscoped, :count).by(-1)
      end

      it "should softdelete the locked article" do
        lambda do
          put :update, id: @article.id, :activate => true
          put :update, id: @article.id, :deactivate => true
          put :destroy, :id => @article.id
        end.should change(Article.unscoped, :count).by 0
      end

    end
  end

  describe "PUT 'update'" do
    describe "for signed-in users" do
      before :each do
        @article = FactoryGirl.create :preview_article, seller: user
        @article_attrs = FactoryGirl.attributes_for :article, categories_and_ancestors: [FactoryGirl.create(:category)]
        @article_attrs.delete :seller
        sign_in user
      end

      it "should update the article with new information" do
        put :update, id: @article.id, article: @article_attrs
        response.should redirect_to @article.reload
      end

      it "changes the articles informations" do
        put :update, id: @article.id, article: @article_attrs
        response.should redirect_to @article.reload
        controller.instance_variable_get(:@article).title.should eq @article_attrs[:title]
      end
    end
  end

  describe "GET 'autocomplete'", search: true do
    before do
      @article = FactoryGirl.create :article, title: 'chunky bacon'
      Article.index.refresh
    end

    it "should be successful" do
      get :autocomplete, keywords: 'chunky'
      response.status.should be 200
      response.body.should eq [{label:"<b>chunky</b> bacon",value:"chunky bacon"}].to_json
    end

    it "should rescue an ECONNREFUSED error" do
      Article.stub(:search).and_raise(Errno::ECONNREFUSED)
      get :autocomplete, keywords: 'chunky'
      response.status.should be 200
      response.body.should eq [].to_json
    end
  end

  describe "GET 'activate'" do
    before do
      sign_in user
      @article = FactoryGirl.create :preview_article, seller: user
    end

    it "should work" do
      put :update, id: @article.id, :activate => true
      response.should redirect_to @article
      flash[:notice].should eq I18n.t 'article.notices.create_html'
    end

    it "should work with an invalid article and set it as new article" do
      @article.title = nil
      @article.save validate: false
      ## we now have an invalid record
      put :update, id: @article.id, :activate => true
      response.should_not redirect_to @article
      response.should redirect_to new_article_path(:edit_as_new => @article.id)
    end
  end

  describe "GET 'deactivate'" do
    before do
      sign_in user
      @article = FactoryGirl.create :article, seller: user
    end

    it "should work" do
      put :update, id: @article.id, :deactivate => true
      response.should redirect_to @article
      flash[:notice].should eq I18n.t 'article.notices.deactivated'
    end

    it "should work with an invalid article" do
      @article.title = nil
      @article.save validate: false
      ## we now have an invalid record
       put :update, id: @article.id, :deactivate => true
      response.should redirect_to @article
      @article.reload.locked?.should == true
    end

  end

end
