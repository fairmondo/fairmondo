require_relative '../test_helper'

describe SessionsController do
  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "GET 'layout'" do
    context "when format is html" do
      it "should use application layout" do
        get :new
        assert_template layout: true
      end
    end

    context "when format is AJAX" do
      context "and the user is logged out" do
        it "should use no layout" do
          xhr :get, :new
          assert_template layout: false
        end
      end

      context "and the user is logged in" do
        let(:user) { FactoryGirl.create :user }
        before { sign_in user, false }

        it "should render the reload site" do
          xhr :get, :new, format: 'html'
          assert_redirected_to toolbox_reload_path
        end
      end
    end
  end

  describe "POST 'create'" do
    it "should set the user_id of an existing cart cookie" do
      skip
    end
  end

  describe "DELETE 'destroy'" do
    it "should delete the cart cookie" do
      skip
    end
  end
end
