require 'spec_helper'

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
      it "should use no layout" do
        xhr :get, :new
        response.should_not render_template("layouts/application")
      end
    end
  end
end
