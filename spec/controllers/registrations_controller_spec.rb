require 'spec_helper'

describe RegistrationsController do

  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "GET 'index" do
    describe "for non-signed-in users" do
      before :each do
        @user = FactoryGirl.create(:user)
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

  describe "POST 'create" do
    before(:each) do
      @valid_params = {
        user: {
          nickname: "johndoe",
          email:    "jdoe@example.com",
          password: "password",
          password_confirmation: "password",
          privacy:  "1",
          legal:    "1",
          agecheck: "1",
          type:     "PrivateUser"
        }
      }
    end

    # describe "given valid data" do
    #   it "should create a user" do
    #     controller.stub(:verify_recaptcha) { true }

    #     lambda do
    #       post :create, @valid_params
    #     end.should change(User.all, :count).by 1
    #   end
    # end

    describe "given invalid data" do
      it "should not create a user wih an invalid recaptcha" do
        controller.stub(:verify_recaptcha) { false }

        lambda do
          post :create, @valid_params
        end.should_not change(User.all, :count)
      end
    end
  end
end