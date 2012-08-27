require 'spec_helper'

describe UsereventsController do
  render_views

  describe "GET 'index" do

    before :each do
      @userevent = FactoryGirl.create(:userevent)
    end

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should render the correct view" do
      get :index
      response.should render_template(@userevent)
    end
  end

  describe "GET 'show" do

    before :each do
      @userevent = FactoryGirl.create(:userevent)
    end

    it "should be successful" do
      get :show, :id => @userevent
      response.should be_success
    end

    it "should render the correct view" do
      get :show, :id => @userevent
      response.should render_template(@userevent)
    end
  end

  describe "GET 'new" do

    before :each do
        @userevent = FactoryGirl.create(:userevent)
      end

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should render the correct view" do
      get :new
      response.should render_template(@userevent)
    end
  end

  describe "POST 'create" do

    before :each do
      @userevent = Factory.attributes_for(:userevent)    
    end

    it "should be successful" do
      post :create, :userevent => @userevent
      response.should be_success
    end

    it "should render the correct view" do
      post :create, :userevent => @userevent
      response.should render_template(@userevent)
    end

    it "should create an userevent" do
      lambda do
        post :create, :userevent => @userevent
      end.should change(Userevent, :count).by(1)
    end
  end

  describe "PUT 'update" do

    before :each do
      @userevent = FactoryGirl.create(:userevent)
    end

    it "should be successful" do
      put :update, :id => @userevent
      response.should render_template(@userevent)
    end

    it "should render the correct view" do
      put :update, :id => @userevent
      response.should render_template(@userevent)
    end
  end

  describe "DELETE 'destroy" do

    before :each do
      @userevent = FactoryGirl.create(:userevent)
    end

    it "should be successful" do
      delete :destroy, :id => @userevent
      response.should redirect_to(userevents_url)
    end

    it "should delete an userevent" do
      lambda do
        delete :destroy, :id => @userevent
      end.should change(Userevent, :count).by(-1)
    end
  end
end