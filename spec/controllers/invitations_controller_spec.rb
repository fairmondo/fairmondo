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

  describe "GET 'show" do

    describe "for signed-in users" do

      before :each do
        @invitation = FactoryGirl.create(:invitation)
        @anotherInvitation = FactoryGirl.create(:invitation)
        sign_in @invitation.sender
      end

      it "should show the correct invitation" do
        get :show, :id => @invitation
        resultInvitation = controller.instance_variable_get(:@invitation)
        resultInvitation.sender.should eq @invitation.sender
        response.should render_template(@invitation)
      end

      it "redirects for show of the wrong invitation" do
        get :show, :id => @invitation
        response.should have_content("#")
      end
    end
  end

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

      it "should be successful" do
        get :new, :user_id => @user.id
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
        sign_in @invitation.sender
      end

      it "should create an invitation" do
        lambda do
          @invitation = FactoryGirl.create(:invitation)
          post :create, id: @invitation
        end.should change(Invitation, :count).by(1)
      end

      it "should create an invitation with the correct sender" do

        @user = @invitation.sender
        post :create, id: @invitation
        @invitation.reload
        @invitation.sender.should eq @user
      end

      it "should invite an already existing user" do
        @user = FactoryGirl.create(:user)
        @invitation_attr = FactoryGirl.attributes_for(:invitation, :email => @user.email)
        post :create, :invitation => @invitation_attr
        response.should redirect_to community_path(:id => @invitation.sender)
      end

      it "should create an invitation and sends it." do
        @invitation_attr = FactoryGirl.attributes_for(:invitation)
        post :create, :invitation => @invitation_attr
      end
    end
  end

  describe "DELETE 'destroy'" do

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

  describe "confirm" do

    before :each do
      @invitation = FactoryGirl.create(:invitation)
    end

    it "should redirect if it's not the correct key" do
      wrong_invitation = FactoryGirl.create(:wrong_invitation)
      get :confirm, id: wrong_invitation
      response.should redirect_to(root_path)
    end

    it "should redirect if already activated" do
      activated_invitation = FactoryGirl.create(:activated_invitation)
      get :confirm, id: activated_invitation
      response.should redirect_to(root_path)
    end

    it "should redirect if no invitation given" do
      get :confirm
      response.should redirect_to(root_path)
    end

    it "forwards to the sign up page" do
      get :confirm, id: @invitation
      response.should redirect_to("/user/sign_up")
    end
  end
end