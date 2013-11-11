require 'spec_helper'

include MassUploadCreator
include CategorySeedData

describe MassUploadsController do

  # Strictly speaking not necessary since already tested in the feature tests
  describe "GET 'new'" do

    context "for non-signed-in users" do

      it "should require login" do
        get :new
        response.should redirect_to(new_user_session_path)
      end

    end

    context "for signed-in users" do
      let(:user) { FactoryGirl.create :user }
      before { sign_in user }

      it "should render the :new view" do
        get :new
        response.should render_template :new
      end
    end
  end


  describe "GET 'image_errors'" do

    context "for signed-in users" do
      let(:user) { FactoryGirl.create :user }
      before { sign_in user }

      it "should render the :new view" do
        get :image_errors
        response.should render_template :image_errors
      end
    end
  end


  describe "mass-upload creation" do
    let(:user) { FactoryGirl.create(:legal_entity, :paypal_data) }
    let(:attributes) { create_attributes('/mass_upload_correct.csv', 'text/csv') }

    before do
      setup_categories
      sign_in user
      post :create, mass_upload: attributes
    end

    describe "POST 'create'" do
      it "should create a mass-upload object" do
        secret_mass_uploads_number = response.redirect_url.dup
        secret_mass_uploads_number.slice!("http://test.host/mass_uploads/")
        response.should redirect_to mass_upload_path(secret_mass_uploads_number)
      end
    end

    describe "PUT 'update'" do
      it "should description" do
        secret_mass_uploads_number = response.redirect_url.dup
        secret_mass_uploads_number.slice!("http://test.host/mass_uploads/")
        post :update, :id => secret_mass_uploads_number
        response.should redirect_to user_path(user)
      end
    end
  end
end