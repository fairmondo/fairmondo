require 'spec_helper'

describe LibrariesController do
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

        get :index, :user_id => @user.id
        response.should redirect_to(new_user_session_path)
      end

    end

    describe "for signed-in users" do

      before :each do

        @library= FactoryGirl.create(:library)

        sign_in @library.user
      end

      it "should be logged in" do
        controller.should be_signed_in
      end

      it "should be successful" do
        get :index, :user_id => @library.user
        response.should be_success
      end

    end

  end
end
