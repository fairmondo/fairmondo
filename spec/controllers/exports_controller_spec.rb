require 'spec_helper'

include MassUploadCreator
include CategorySeedData

describe ExportsController do

  describe "mass-upload creation" do
    before do
      setup_categories
      user = FactoryGirl.create :legal_entity, :paypal_data
      article = FactoryGirl.create :article, seller: user
      sign_in user
    end

    describe "GET 'show'" do
      it "should be successful" do
        time = Time.now
        Time.stub(:now).and_return(time)
        get :show, :kind_of_article => "active", :format => "csv"
        response.content_type.should eq("text/csv")
        response.headers["Content-Disposition"].should eq("attachment; filename=\"Fairnopoly_export_#{time.strftime("%Y-%d-%m %H:%M:%S")}.csv\"")
        response.should be_success
      end
    end
  end
end
