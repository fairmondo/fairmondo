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
  
end
