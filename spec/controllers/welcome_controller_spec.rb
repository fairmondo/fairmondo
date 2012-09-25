require 'spec_helper'

describe WelcomeController do
  render_views

  describe "GET 'index" do

     describe "for non-signed-in users" do 

      it "should be successful" do
        get :index
        response.should be_success
      end
    end

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "should be successful" do
        get :index
        response.should be_success
      end      
    end  
  end
end