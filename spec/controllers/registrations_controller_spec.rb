require 'spec_helper'

describe RegistrationsController do
  render_views

  describe "GET 'index" do

    describe "for non-signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        request.env['devise.mapping'] = Devise.mappings[:user]
      end

      it "should be a guest" do
        controller.should_not be_signed_in
      end

      it "should deny access" do
      
        get :edit
        response.should redirect_to(new_user_session_path)
      end
      
    end

    describe "for signed-in users" do

      before :each do
        request.env['devise.mapping'] = Devise.mappings[:user]
        @user = FactoryGirl.create(:user)
 
        sign_in @user
      end

     

      it "should be logged in" do
        controller.should be_signed_in
      end

      it "should be successful" do
        get :edit
        response.should be_success
      end

      it "should sucessfully update a user" do
         @attr = {:country => "Deutschland" , :zip => "87666", :email => @user.email}
         
         put :update, :user => @attr
         
        response.should redirect_to @user.reload
        controller.instance_variable_get(:@user).zip.should eq @attr[:zip]
        
      end
      
      
        
    end
    
  end


end