require 'spec_helper'

describe MessagesController do

  describe "GET 'index'" do

    describe "for signed-out users" do
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
    end
  end

  describe "GET 'show'" do
    before :each do
      @sender = FactoryGirl.create :user
      @recipient = FactoryGirl.create :user

      @message = FactoryGirl.create :message, sender_id: @sender.id, recipient_id: @recipient.id
    end

    describe "for signed-out users" do
      it "should be a guest" do
        controller.should_not be_signed_in
      end

      it "should deny access" do
        get :show, :id => @message
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "for signed-in users" do
      before :each do
        sign_in @sender
      end

      it "should be logged in" do
        controller.should be_signed_in
      end

      it "should be successful" do
        get :show, :id => @message
        response.should be_success
      end
    end
  end


  describe "GET 'new'" do

    describe "for signed-out users" do
      it "should be a guest" do
        controller.should_not be_signed_in
      end

      it "should deny access" do
        get :new
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "for signed-in users" do
      before :each do
        @sender = FactoryGirl.create :user
        @recipient = FactoryGirl.create :user
        sign_in @sender
      end

      it "should be logged in" do
        controller.should be_signed_in
      end

      it "should be successful" do
        get :new, :id => @recipient
        response.should be_success
      end
    end
  end
end