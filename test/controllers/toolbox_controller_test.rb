require 'test_helper'

describe ToolboxController do

  let(:user) { FactoryGirl.create :user }

  #render_views

  describe "GET 'session_expired'" do
    describe "as json" do
      it "should be successful" do
        get :session_expired, format: :json
        assert_response :success
      end
    end

    describe "as html" do
      it "should fail" do
        ->{ get :session_expired }.must_raise ActionController::UnknownFormat
      end
    end
  end

   describe "GET 'confirm'" do
    describe "as js" do
      it "should be successful" do
        xhr :get, :confirm, format: :js
        assert_response :success
      end
    end

    describe "as html" do
      it "should fail" do
        -> { get :confirm }.must_raise ActionController::UnknownFormat
      end
    end
  end

  describe "GET 'rss'" do
    before(:each) do
      FakeWeb.register_uri(:get, 'https://info.fairnopoly.de/?feed=rss', :body => "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><rss version=\"2.0\"></rss>")
    end

    describe "as html" do
      it "should be successful" do
        get :rss
        assert_response :success
      end
    end

    describe "as json" do
      it "should fail" do
        -> { get :rss, format: :json }.must_raise ActionController::UnknownFormat
      end
    end

    describe "on timeout" do
      it "should be sucessful and return nothing" do
        Timeout.stubs(:timeout).raises(Timeout::Error)
        get :rss
        assert_response :success
      end
    end
  end

  describe "GET 'reload'" do
    it "should be successful" do
      get :reload
      assert_response :success
    end

    it "should not render a layout" do
      get :reload
      assert_template layout: false
    end
  end

  describe "GET 'healthcheck'" do
    it "should be successful" do
      get :healthcheck
      assert_response :success
    end

    it "should not render a layout" do
      get :healthcheck
      assert_template layout: false
    end
  end

  describe "#newsletter_status " do

    before do
      sign_in user
    end
    it "should be successful" do
      CleverreachAPI.expects(:get_status).with(user)
      get :newsletter_status, format: :json
      assert_response :success
    end

    it "should not render a layout" do
      CleverreachAPI.expects(:get_status).with(user)
      get :newsletter_status, format: :json
      assert_template layout: false
    end

    it "should call the Cleverreach API with the logged in user" do
      CleverreachAPI.expects(:get_status).with(user)
      get :newsletter_status, format: :json
    end

  end

  describe "GET 'notice'" do
    before do
      @notice = FactoryGirl.create :notice
      sign_in user
    end

    it "should redirect to the notice path and close it" do
      get :notice, :id => @notice.id
      assert_redirected_to(@notice.path)
      @notice.reload.open.must_equal false
    end
  end

  describe "PUT reindex" do
    before do
      sign_in user
    end

    describe "for normal users" do
      it "should not be allowed" do
        -> { put :reindex, article_id: 1 }.must_raise Pundit::NotAuthorizedError
      end
    end

    describe "for admin users" do
      let(:user) { FactoryGirl.create :admin_user }
      it "should do something" do
        article = FactoryGirl.create :article
        Indexer.expects(:index_article).with(article)

        request.env["HTTP_REFERER"] = '/'
        put :reindex, article_id: article.id
      end
    end
  end
end
