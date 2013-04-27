require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'index" do

    describe "for non-signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
      end

      it "should be a guest" do
        controller.should_not be_signed_in
      end

      it "should deny access" do
        get :show
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
        get :show, :id => @user
        response.should be_success
      end

      it "should be successful" do
        get :show
        response.should be_success
      end

      
    end
  end
  
  
#  describe "community" do
#
#    describe "for non-signed-in users" do
#
#      it "should deny access" do
#        get :community
#        response.should redirect_to(new_user_session_path)
#      end
#    end

#    describe "for signed-in users" do
#
#      before :each do
#        @user = FactoryGirl.create(:user)
#        sign_in @user
#      end

#      it "should be successful" do
#        get :community
#        response.should be_success
#      end
#    end
#  end

#  describe "search_users" do
#
#    describe "for non-signed-in users" do
#
#      it "should deny access" do
#        get :search_users
#        response.should redirect_to(new_user_session_path)
#      end
#    end
#
#    describe "for signed-in users" do
#
#      before :each do
#        @user = FactoryGirl.create(:user)
#        sign_in @user
#      end
#
#      it "should be successful" do
#        get :search_users
#        response.should be_success
#      end
#
#     
#    end
#  end

# describe "list_followers" do
#
#    describe "for non-signed-in users" do
#
#      it "should deny access" do
#        get :list_followers
#        response.should redirect_to(new_user_session_path)
#      end
#    end
#
#    describe "for signed-in users" do
#
#      before :each do
#        @user = FactoryGirl.create(:user)
#        sign_in @user
#      end
#
#      it "should be successful" do
#        get :list_followers
#        response.should be_success
#      end
#    end
#  end

#  describe "list_following" do
#
#    describe "for non-signed-in users" do
#
#      it "should deny access" do
#        get :list_following
#        response.should redirect_to(new_user_session_path)
#      end
#    end
#
#    describe "for signed-in users" do
#
#      before :each do
#        @user = FactoryGirl.create(:user)
#        sign_in @user
#      end
#
  #TODO
  #   it "should be successful" do
  #      get :list_following
  #      response.should be_success
  #    end
#    end
#  end

#  describe "follow" do
#
#    describe "for non-signed-in users" do
#
#      it "should deny access" do
#        get :follow
#        response.should redirect_to(new_user_session_path)
#      end
#    end
#
#    describe "for signed-in users" do
#
#      before :each do
#        @user = FactoryGirl.create(:user)
#        sign_in @user
#      end

#      it "should be successful" do
#        get :follow, :id => @user
#        response.should have_content("#")
#      end
#    end
#  end
  
#  describe "stop_follow" do
#
#    describe "for non-signed-in users" do
#
#      it "should deny access" do
#        get :stop_follow
#        response.should redirect_to(new_user_session_path)
#      end
#    end

#    describe "for signed-in users" do
#
#      before :each do
#        @user = FactoryGirl.create(:user)
#        sign_in @user
#      end

#      it "should be successful" do
#        get :stop_follow, :id => @user
#        response.should have_content("#")
#      end
#    end
#  end

end