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
        get :index, :id => @user
        response.should be_success
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      
      context "my auction templates" do 
        before :each do
          @auction_template = FactoryGirl.create(:auction_template, :user => @user)
        end
    
        it "assigns all auction_templates as @auction_templates" do
          get :index, {}
          assigns(:auction_templates).should eq([@auction_template])
        end
      end
      
      
    end
  end
  
  describe "library-functionality" do

    describe "for non-signed-in users" do

      it "should be a guest" do
        controller.should_not be_signed_in
      end

      it "should deny access" do
        get :index
        response.should redirect_to(new_user_session_path)
      end
      
      it "should deny access" do
         post :new_library, :library_name => "test-lib"
        response.should redirect_to(new_user_session_path)
      end
      
    end

    describe "for signed-in users" do
      before :each do
        @library = FactoryGirl.create(:library_with_elements)
        @user = @library.user
        
        sign_in @user
      end
      
      it "should be successful" do
        get :libraries
        response.should be_success
      end
      
      it "should return the library" do
        get :libraries
        controller.instance_variable_get(:@libraries).should == [@library]
      end
      
      it "should add a new library" do
        lambda do
          post :new_library, :library_name => "test-lib" 
        end.should change(Library, :count).by(1)
      end
      
      it "sould set library public" do
       
        get :set_library_public , :id => @library.id
        @library.reload
        @library.public.should == true
      end
      
      it "sould set library private" do
        @library.public=true
        get :set_library_private , :id => @library.id
        @library.reload
        @library.public.should == false
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