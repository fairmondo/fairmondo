require 'spec_helper'

describe StatisticsController do
  context "as an admin" do
    before { sign_in FactoryGirl.create :admin_user }

    describe "GET 'general'" do
      it "should be successful" do
        get :general
        response.should be_success
      end
    end

    describe "GET 'category_sales'" do
      it "should be successful" do
        get :category_sales
        response.should be_success
      end
    end
  end

  #context "as a random user" do #-- gets tested by policy spec
end
