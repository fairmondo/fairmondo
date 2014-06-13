require 'test_helper'

describe SessionsController do
  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "GET 'layout'" do
    context "when format is html" do
      it "should use application layout" do
        get :new
        response.should render_template("layouts/application")
      end
    end

    context "when format is AJAX" do
      context "and the user is logged out" do
        it "should use no layout" do
          xhr :get, :new
          response.should_not render_template("layouts/application")
        end
      end

      context "and the user is logged in" do
        let(:user) { FactoryGirl.create :user }
        before { sign_in user, false }

        it "should render the reload site" do
          xhr :get, :new, format: 'html'
          response.should redirect_to toolbox_reload_path
        end
      end
    end
  end
end
