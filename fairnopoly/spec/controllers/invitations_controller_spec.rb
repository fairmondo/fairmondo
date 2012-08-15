require 'spec_helper'

describe InvitationsController do
  render_views

  describe "GET 'index" do

    describe "for non-signed-in users" do 

      it "should deny access" do
        get :index
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "for signed-in users" do

      before :each do
        @invitation = FactoryGirl.create(:invitation)
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should render the correct view" do
        get :index
        response.should render_template(@invitation)
      end
    end
  end
=begin 
  describe "GET 'show" do
    
    describe "for non-signed-in users" do 
      
      it "should deny access" do
        get :show
        response.should redirect_to(new_user_session_path)
      end
    end
   
    describe "for signed-in users" do

      before :each do
        @invitation = FactoryGirl.create(:invitation)
        @invitation.sender = FactoryGirl.create(:user)
        sign_in @invitation.sender
      end

      it "should show the correct invitation" do
        get :show, id: @invitation
        resultInvitation = controller.instance_variable_get(:@invitation)
        resultInvitation.sender.should eq @invitation.sender  
      end
    end  
  end
=end
  describe "GET 'new'" do

    describe "for non-signed-in users" do 

      it "should deny access" do
        get :new
        response.should redirect_to(new_user_session_path)
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
    end
  end

  describe "POST 'create'" do

    describe "for non-signed-in users" do 

      before :each do
        @invitation = FactoryGirl.create(:invitation)
      end

        it "should deny access" do
          get :create
          response.should redirect_to(new_user_session_path)
        end

        it "should not create an invitation" do
          lambda do
            post :create, id: @invitation
          end.should_not change(Invitation, :count)
        end
    end

    describe "for signed-in users" do

      before :each do
        @invitation = FactoryGirl.create(:invitation)
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "should create an invitation" do
        lambda do
          @invitation = FactoryGirl.create(:invitation)
          post :create, id: @invitation
        end.should change(Invitation, :count).by(1)
      end

      it "should create an invitation with the correct sender" do
        post :create, id: @invitation
        resultInvitation = controller.instance_variable_get(:@invitation)
        resultInvitation.sender.should eq @user
      end
    end
  end
=begin
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
        @ffp  = FactoryGirl.create(:ffp)
        sign_in @user
      end

      it "should be successful" do
        put :update, id: @ffp
        response.should redirect_to(ffps_path)
      end
    end
  end
=end
  describe "DELETE 'destroy'" do

    describe "for non-signed-in users" do

      it "should deny access" do
        delete :destroy
        response.should redirect_to(new_user_session_path)
      end

      it "should not delete an invitation" do
        lambda do
          delete :destroy
        end.should_not change(Invitation, :count)
      end
    end

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        @invitation = FactoryGirl.create(:invitation)
        sign_in @user
      end

      it "should delete an invitation" do
        lambda do
          delete :destroy, :id => @invitation
        end.should change(Invitation, :count).by(-1)
      end

      it "should redirect to the correct page" do
        delete :destroy, :id => @invitation
        response.should redirect_to(invitations_url)
      end
    end
  end
end