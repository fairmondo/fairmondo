require 'spec_helper'

describe AuctionsController do
  render_views
  
  describe "GET 'index" do
    
    describe "for non-signed-in users" do

      it "should be a guest" do
        controller.should_not be_signed_in
      end

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
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "should be logged in" do
        controller.should be_signed_in
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should render the :index view" do
        get :index
        response.should render_template :index
      end
    end
  end
  
  describe "GET 'show" do

    before :each do
      @user = FactoryGirl.create(:user)
      @auction  = FactoryGirl.create(:auction)
    end
    
    describe "for non-signed-in users" do

      it "should be successful" do
        get :show, id: @auction
        response.should be_success
      end

      it "should render the :show view" do
        get :show, id: @auction
        response.should render_template :show
      end
    end

    describe "for signed-in users" do

      it "should be successful" do
        sign_in @user
        get :show, :id => @auction
        response.should be_success
      end

      it "should render the :show view" do
        sign_in @user
        get :show, id: @auction
        response.should render_template :show
      end
    end
  end

  describe "GET 'new'" do

    describe "for non-signed-in users" do

      it "should be successful" do
        get :new
        response.should be_success
      end

      it "should render the :new view" do
        get :new
        response.should render_template :new
      end
    end

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "should be successful" do
        get :new
        response.should be_success
      end

      it "should render the :new view" do
        get :new
        response.should render_template :new
      end
    end
  end

  describe "GET 'edit'" do

    describe "for non-signed-in users" do

      it "should deny access" do
        get :edit
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        @auction = FactoryGirl.create(:auction)
        sign_in @user
      end

      it "should be successful" do
        auction = FactoryGirl.create(:auction)
        get :show, :id => auction
        response.should be_success
      end
    end

      it "should not change auctions count" do
        lambda do
          get :edit
        end.should_not change(Auction, :count)
      end
  end

  describe "POST 'create'" do

    describe "for non-signed-in users" do

        it "should be successful" do
          get :create
          response.should be_success
        end

        it "should render the :new view" do
          get :create
          response.should render_template :new
        end

        it "should create an auction" do
          lambda do
            auction = FactoryGirl::create(:auction)
            post :create, id: auction
          end.should change(Auction, :count).by(1)
        end
    end

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "should render the :new view" do
          post :create
          response.should render_template :new
        end

      it "should create an auction" do
        lambda do
          auction = FactoryGirl::create(:auction)
          post :create, id: auction
        end.should change(Auction, :count).by(1)
      end
    end
  end

  describe "PUT 'update'" do

    describe "for non-signed-in users" do

      it "should deny access" do
        put :update
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        @auction = FactoryGirl::create(:auction)
        sign_in @user
      end

      it "should update the auction" do
        put :update, id: @auction
        response.should redirect_to(@auction)
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for non-signed-in users" do

      it "should deny access" do
        delete :destroy
        response.should redirect_to(new_user_session_path)
      end

      it "should not delete an auction" do
        lambda do
          delete :destroy
        end.should_not change(Ffp, :count)
      end
    end

      describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        @auction  = FactoryGirl.create(:auction)
        sign_in @user
      end

      it "should delete an auction" do
        lambda do
          delete :destroy, :id => @auction
        end.should change(Auction, :count).by(-1)
      end
    end
  end
end