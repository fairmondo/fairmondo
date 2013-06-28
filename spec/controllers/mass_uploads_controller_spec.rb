# bugbug Isn't that all tested in /features/mass_upload_spec.rb already?

require 'spec_helper'

include MassUploadCreator
include CategorySeedData

describe MassUploadsController do
  render_views

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
        # bugbugb seems like there is no way to access the secret_mass_uploads_number
        post :create, mass_upload: @attributes
        # response.should be_redirect

        # controller.instance_variable
        # puts @test
        # response.should redirect_to(new_mass_upload_path)
        p ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        p response.redirect_url
        # p ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        # p session
        # p ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        # redirect_to(new_mass_upload_path)

        # secret_mass_uploads_number.should == @user
        # session[secret_mass_uploads_number].should_not be_empty
      end
    end

  end
end
