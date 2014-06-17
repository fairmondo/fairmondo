require 'test_helper'

describe ExportsController do

  describe "mass-upload creation" do
    before do
      @user = FactoryGirl.create :legal_entity, :paypal_data
      article = FactoryGirl.create :article, seller: @user
      sign_in @user
    end

    describe "GET 'show'" do
      it "should be successful" do
        time = Time.now
        Time.stubs(:now).returns(time)
        get :show, :kind_of_article => "active", :format => "csv"
        response.content_type.must_equal("text/csv; charset=utf-8")
        response.headers["Content-Disposition"].must_equal("attachment; filename=\"Fairnopoly_export_#{time.strftime("%Y-%d-%m %H:%M:%S")}.csv\"")
        assert_response :success
      end
    end


  end
end
