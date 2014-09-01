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
    before do
      @user = FactoryGirl.create :user, email: 'cookie@test.de'
      @cart = FactoryGirl.create(:cart, user: nil)
      cookies.signed[:cart] = @cart.id
    end
    it "should set the user_id of an existing cart cookie" do
      post :create, :user => {:email => @user.email, :password => 'password'}
      @cart.reload.user.must_equal @user
    end
  end

  describe "DELETE 'destroy'" do
    before do
      user = FactoryGirl.create :user
      sign_in user
      cookies.signed[:cart] = 1
    end
    it "should delete the cart cookie" do
      get :destroy
      cookies.signed[:cart].must_equal nil
    end
  end
end
