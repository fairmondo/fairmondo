require 'spec_helper'

describe FfpsController do
  render_views
  
  describe "GET 'index" do
    
    describe "for non-signed-in users" do 
      
      it "should deny access" do
        get :index
        response.should redirect_to('/users/sign_in')
      end
    end
    
    describe "for signed-in users" do
      
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end
      
      it "it should be successful" do
        get :index
        response.should be_success
      end      
    end  
  end
  
  describe "GET 'show" do
    
    describe "for non-signed-in users" do 
      
      it "should deny access" do
        get :show
        response.should redirect_to('/users/sign_in')
      end
    end
    
    describe "for signed-in users" do
      
      before :each do
        @user = FactoryGirl.create(:user)
        @ffp  = FactoryGirl.create(:ffp)
        sign_in @user
      end
      
      it "it should be successful" do
        get :show, id: @ffp
        response.should be_success
      end      
    end  
  end
  
  describe "GET 'new'" do

    describe "for non-signed-in users" do 

      it "should deny access" do
        get :new
        response.should redirect_to('/users/sign_in')
      end
    end

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "it should be successful" do
        get :new
        response.should be_success
      end
    end
  end

  describe "POST 'create'" do

    describe "for non-signed-in users" do 

      before :each do
        @goodPrice = { :price => Random.new.rand(10..500)}
      end

        it "should deny access" do
          get :create
          response.should redirect_to('/users/sign_in')
        end

        it "should not create a ffp" do
          lambda do
            post :create, :ffp => @goodPrice
          end.should_not change(Ffp, :count)
        end
    end

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        @goodPrice  = { :price => Random.new.rand(10..500)}
        @lowPrice   = { :price => Random.new.rand(0..9)}
        @highPrice  = { :price => Random.new.rand(500..9999999)}
        sign_in @user
      end

      it "should create a ffp" do
        lambda do
          post :create, :ffp => @goodPrice
        end.should change(Ffp, :count).by(1)
      end

      it "should not create a ffp (price low)" do
        lambda do
          post :create, :ffp => @lowPrice
        end.should_not change(Ffp, :count)
      end

      it "should not create a ffp (price high)" do
        lambda do
          post :create, :ffp => @highPrice
        end.should_not change(Ffp, :count)
      end

    end 
  end

  describe "PUT 'update'" do

    describe "for non-signed-in users" do 

      it "should deny access" do
        put :update
        response.should redirect_to('/users/sign_in')
      end
    end

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        @ffp  = FactoryGirl.create(:ffp)
        sign_in @user
      end

      it "it should be successful" do
        put :update, id: @ffp
        response.should redirect_to(ffps_path)
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for non-signed-in users" do 

      it "should deny access" do
        delete :destroy
        response.should redirect_to('/users/sign_in')
      end

      it "should not delete ffp" do
        lambda do
          delete :destroy
        end.should_not change(Ffp, :count)
      end
    end

      describe "for signed-in users" do # fails

      before :each do
        @user = FactoryGirl.create(:user)
        @ffp  = FactoryGirl.create(:ffp)
        sign_in @user
      end

      it "should create a ffp" do
        lambda do
          delete :destroy, :id => @ffp
        end.should_not change(Ffp, :count)
      end
    end

    describe "for admin users" do

      before :each do
        admin = FactoryGirl.create(:user, :admin => true) 
        sign_in admin
        @ffp  = FactoryGirl.create(:ffp)
      end

      it "should create a ffp" do
        lambda do
          delete :destroy, :id => @ffp
        end.should change(Ffp, :count).by(-1)
      end
    end
  end

end
