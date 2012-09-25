require 'spec_helper'

describe CategoriesController do
  render_views
  
  describe "GET 'index" do

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should render the :index view" do
      get :index
      response.should render_template :index
    end
  end

  describe "GET 'show'" do
    
    before :each do
      @category = FactoryGirl.create(:category)
    end

    it "should be successful" do
      get :show, id: @category
      response.should be_success
    end

    it "should render the :show view" do
      get :show, id: @category
      response.should render_template :show
    end
  end

  describe "GET 'new'" do

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should render the :new view" do
      get :new
      response.should render_template :new
      #render partial maybe?
    end
  end

    describe "GET 'edit'" do

    before :each do
      @category = FactoryGirl.create(:category)
    end

    it "should be successful" do
      get :edit, id: @category
      response.should be_success
    end

    it "should render the :edit view" do
      get :edit, id: @category
      response.should render_template :edit
    end
  end
  
  describe "POST 'create'" do

    it "should be successful" do
      post :create
      response.should redirect_to "/categories/1"
    end

    it "should change the count of categories" do
      lambda do
        post :create
      end.should change(Category, :count).by(1)
    end
  end

  describe "PUT 'update'" do

    before :each do
      @category = FactoryGirl.create(:category)
    end

    it "should be successful" do
      put :update, id: @category
      response.should redirect_to @category
    end

    it "should not change the count of categories" do
      lambda do
        put :update, id: @category
      end.should_not change(Category, :count)
    end
  end

  describe "DELETE 'destroy'" do

    before :each do
      @category = FactoryGirl.create(:category)
    end

    it "should be successful" do
      delete :destroy, id: @category
      response.should redirect_to categories_url
    end

    it "should change the count of categories" do
      lambda do
        delete :destroy, id: @category
      end.should change(Category, :count).by(-1)
    end
  end
end