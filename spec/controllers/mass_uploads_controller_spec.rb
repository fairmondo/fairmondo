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

  describe "POST 'create'" do

    before do
      setup_categories
      # bugbug Instance variables needed?
      @user = FactoryGirl.create(:user)
      @attributes = create_attributes('/mass_upload_correct.csv', 'text/csv')
    end

    describe "for signed-in users" do

      before :each do
        sign_in @user
      end

      it "should create a mass-upload object" do
        post :create, mass_upload: @attributes
        secret_mass_uploads_number = response.redirect_url.dup
        secret_mass_uploads_number.slice!("http://test.host/mass_uploads/")
        response.should redirect_to mass_upload_path(secret_mass_uploads_number)
      end
    end
  end
end
