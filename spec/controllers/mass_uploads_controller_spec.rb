require 'spec_helper'

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
      let(:user) { FactoryGirl.create :legal_entity }
      before { sign_in user }

      it "should render the :new view" do
        get :new
        response.should render_template :new
      end
    end
  end

  describe "mass-upload creation" do
    let(:user) { FactoryGirl.create(:legal_entity, :paypal_data) }
    let(:attributes) { FactoryGirl.attributes_for(:mass_upload, :user => user) }

    before do
      sign_in user
    end

    describe "POST 'create'" do
      it "should create a mass-upload object" do
        expect { post :create, mass_upload: attributes }
                  .to change(MassUpload, :count).by(1)
        response.should redirect_to user_path(user, :anchor => 'my_mass_uploads')
      end
    end

    describe "PUT 'update'" do
      it "should description" do
        post :create, mass_upload: attributes
        post :update, :id => MassUpload.last.id
        response.should redirect_to user_path(user)
      end
    end
  end
end