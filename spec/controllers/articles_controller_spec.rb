#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'spec_helper'

describe ArticlesController do
  render_views
  include CategorySeedData

  describe "GET 'index'" do

    describe "search", :search => true do
      before :each do
        setup_categories
        @vehicle_category = Category.find_by_name!("Fahrzeuge")
        @article  = FactoryGirl.create(:second_hand_article, :title => "muscheln", :categories_and_ancestors => @vehicle_category.self_and_ancestors.map(&:id) )
        Sunspot.commit
      end

      it "should find the article with title 'muscheln' when searching for muscheln" do
        get :index, :article => {:title => "muscheln" }
        controller.instance_variable_get(:@articles).should == [@article]
      end

      it "should find the article with title 'muscheln' when searching for muschel" do
        get :index, :article => {:title => "muschel" }
        controller.instance_variable_get(:@articles).should == [@article]
      end

      context "when filtering by categories" do
        before :each do
          @hardware_category = Category.find_by_name!("Hardware")
          @hardware_article  = FactoryGirl.create(:second_hand_article, :title => "muscheln 2", :categories_and_ancestors => @hardware_category.self_and_ancestors.map(&:id))
          Sunspot.commit
        end

        it "should find the article in category 'Hardware' when filtering for 'Hardware'" do
          @electronic_category = Category.find_by_name!("Elektronik")
          get :index, :article => {:categories_and_ancestors => @hardware_category.self_and_ancestors.map(&:id)}
          controller.instance_variable_get(:@articles).should == [@hardware_article]
        end

        it "should find the article in category 'Hardware' when filtering for the ancestor 'Elektronik'" do
          @electronic_category = Category.find_by_name!("Elektronik")
          get :index, :article => {:categories_and_ancestors => @electronic_category.self_and_ancestors.map(&:id)}
          controller.instance_variable_get(:@articles).should == [@hardware_article]
        end

        it "should not find the article in category 'Hardware' when filtering for 'Software'" do
          @software_category = Category.find_by_name!("Software")
          get :index, :article => {:categories_and_ancestors => @software_category.self_and_ancestors.map(&:id)}
          controller.instance_variable_get(:@articles).should == []
        end

#        context "#categories_with_ancestors" do
#          context "when passing a category_id without its ancestors" do
#            it "should remove the orphan descendants from the passed subtree" do
#              @audio_category = Category.find_by_name!("Audio & HiFi")
#              get :index, :article => {:categories_and_ancestors => @audio_category.self_and_ancestors.map(&:id) + [@hardware_category.id] }
#              controller.instance_variable_get(:@articles).should == []
#            end
#          end
#        end

        context "and searching for 'muscheln'" do

          it "should find all articles with title 'muscheln' with an empty categories filter" do
            get :index, :article => {:categories_and_ancestors => [], :title => "muscheln"}
            controller.instance_variable_get(:@articles).should == [@article, @hardware_article]
          end

          it "should chain both filters" do
            get :index, :article => {:categories_and_ancestors => @hardware_category.self_and_ancestors.map(&:id), :title => "muscheln"}
            controller.instance_variable_get(:@articles).should == [@hardware_article]
          end

          context "and filtering for condition" do

            before :each do
              @no_second_hand_article = FactoryGirl.create :no_second_hand_article, title: "muscheln 3", categories_and_ancestors: @hardware_category.self_and_ancestors.map(&:id)
              Sunspot.commit
            end

            it "should find all articles with title 'muscheln' with empty condition and category filter" do
              get :index, article: {categories_and_ancestors: [], title: "muscheln"}
              controller.instance_variable_get(:@articles).should == [@article, @hardware_article, @no_second_hand_article]
            end

            it "should chain all filters" do
              get :index, article: {categories_and_ancestors: @hardware_category.self_and_ancestors.map(&:id), title: "muscheln", condition: "old"}
              controller.instance_variable_get(:@articles).should == [@hardware_article]
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
        @user = FactoryGirl.create :user
        @article = FactoryGirl.create :article
        sign_in @user
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

    before :each do
      @user = FactoryGirl.create :user
      @article  = FactoryGirl.create :article
    end

    describe "for all users" do
      it "should be successful" do
        get :show, id: @article
        response.should be_success
      end

      it "should render the :show view" do
        get :show, id: @article
        response.should render_template :show
      end
    end

    # describe "for signed-in users" do
    #   before do
    #     sign_in @user
    #   end

    #   it "should be successful" do
    #     get :show, id: @article
    #     response.should be_success
    #   end

    #   it "should render the :show view" do
    #     get :show, id: @article
    #     response.should render_template :show
    #   end
    # end
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
        @user = FactoryGirl.create :user
        sign_in @user
      end

      it "should render the :new view" do
        get :new
        response.should render_template :new
      end

      it "should be possible to get a new article from an existing one" do
        @article = FactoryGirl.create :article, :without_image , :seller => @user
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
        @user = FactoryGirl.create :user
        sign_in @user
      end

      context 'his articles' do
        before :each do
          @article = FactoryGirl.create :preview_article, seller: @user


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
      @user = FactoryGirl.create(:user)
      @article_attrs = FactoryGirl.attributes_for :article, categories_and_ancestors: [FactoryGirl.create(:category)]
      @article_attrs[:transaction_attributes] = FactoryGirl.attributes_for :transaction
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
        sign_in @user
      end

      it "should create an article" do
        lambda do
          post :create, article: @article_attrs
        end.should change(Article.unscoped, :count).by 1
      end

      it "should not raise an error for very high quantity values" do
        post :create, :article => @article_attrs.merge(quantity: "100000000000000000000000")
        response.should render_template :new
        response.response_code.should == 200
      end

    end

    describe "nesting user forms" do

      before :each do
        sign_in @user
        @article_attrs[:seller_attributes] = FactoryGirl.attributes_for :nested_seller_update
        @article_attrs[:seller_attributes][:id] = @user.id
        @article_attrs[:payment_bank_transfer] = true
      end

      it "should update the users bank info" do
        lambda do
          post :create, :article => @article_attrs
        end.should change(Article.unscoped, :count).by 1

        @user.reload
        @user.bank_code.should eq @article_attrs[:seller_attributes][:bank_code]
      end


      it "should not update the users invalid attributes" do
         begin
          @article_attrs[:seller_attributes][:nickname] = Faker::Internet.user_name
        end while @article_attrs[:seller_attributes][:nickname] == @user.nickname

        lambda do
          post :create, :article => @article_attrs
        end.should raise_error SecurityError

        @user.reload
        @user.nickname.should_not eq @article_attrs[:seller_attributes][:nickname]

      end
    end
  end

  #TODO: add more tests for delete
  describe "PUT 'destroy'" do
    describe "for signed-in users" do
      before :each do
        @user = FactoryGirl.create :user
        @article = FactoryGirl.create :preview_article, seller: @user
        @article_attrs = FactoryGirl.attributes_for :article, categories_and_ancestors: [FactoryGirl.create(:category)]
        @article_attrs.delete :seller
        @article_attrs[:transaction_attributes] = FactoryGirl.attributes_for :transaction
        sign_in @user
      end

      it "should delete the preview article" do
        lambda do
          put :destroy, :id => @article.id
          response.should redirect_to(articles_path)
        end.should change(Article.unscoped, :count).by -1
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
        @user = FactoryGirl.create :user
        @article = FactoryGirl.create :preview_article, seller: @user
        @article_attrs = FactoryGirl.attributes_for :article, categories_and_ancestors: [FactoryGirl.create(:category)]
        @article_attrs.delete :seller
        @article_attrs[:transaction_attributes] = FactoryGirl.attributes_for :transaction
        sign_in @user
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
      Sunspot.commit
    end

    it "should be successful" do
      get :autocomplete, keywords: 'chunky'
      response.status.should be 200
      response.body.should eq ["chunky bacon"].to_json
    end

    it "should rescue an ECONNREFUSED error" do
      Sunspot.stub(:search).and_raise(Errno::ECONNREFUSED)
      get :autocomplete, keywords: 'chunky'
      response.status.should be 200
      response.body.should eq [].to_json
    end
  end

  describe "GET 'activate'" do
    before do
      @user = FactoryGirl.create :user
      sign_in @user
      @article = FactoryGirl.create :preview_article, seller: @user
    end

    it "should work" do
      put :update, id: @article.id, :activate => true
      response.should redirect_to @article
      flash[:notice].should eq I18n.t 'article.notices.create'
    end

    it "should not work with an invalid article" do
      @article.title = nil
      @article.save validate: false
      ## we now have an invalid record
      put :update, id: @article.id, :activate => true
      response.should_not redirect_to @article
      response.should render_template "edit"
    end
  end

  describe "GET 'deactivate'" do
    before do
      @user = FactoryGirl.create :user
      sign_in @user
      @article = FactoryGirl.create :article, seller: @user
    end

    it "should work" do
      put :update, id: @article.id, :deactivate => true
      response.should redirect_to @article
      flash[:notice].should eq I18n.t 'article.notices.deactivated'
    end

    it "should not work with an invalid article" do
      @article.title = nil
      @article.save validate: false
      ## we now have an invalid record
       put :update, id: @article.id, :deactivate => true
      response.should_not redirect_to @article
      response.should render_template "edit"
    end
  end
end
