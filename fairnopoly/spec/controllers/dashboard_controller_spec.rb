require 'spec_helper'

describe DashboardController do
  render_views

  describe "GET 'index" do

    describe "for non-signed-in users" do 

      it "should be a guest" do
        controller.should_not be_signed_in
      end

      it "should deny access" do
        get :index
        response.should redirect_to(new_user_session_path)
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
        sign_in @user
      end

      it "should be successful" do
        put :update, id: @user
        response.should redirect_to(dashboard_path)
      end
    end
  end
end