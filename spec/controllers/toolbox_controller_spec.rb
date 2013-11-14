require 'spec_helper'

describe ToolboxController do

  let(:user) { FactoryGirl.create :user }

  #render_views

  describe "GET 'session_expired'" do
    context "as json" do
      it "should be successful" do
        get :session_expired, format: :json
        response.should be_success
      end
    end

    context "as html" do
      it "should fail" do
        get :session_expired
        response.should_not be_success
      end
    end
  end

   describe "GET 'confirm'" do
    context "as js" do
      it "should be successful" do
        get :confirm, format: :js
        response.should be_success
      end
    end

    context "as html" do
      it "should fail" do
        get :confirm
        response.should_not be_success
      end
    end
  end

  describe "GET 'rss'" do
    before(:each) do
      RSS::Parser.stub_chain(:parse,:items,:first).and_return([])
    end

    context "as html" do
      it "should be successful" do
        get :rss
        response.should be_success
      end
    end

    context "as json" do
      it "should fail" do
        get :rss, format: :json
        response.should_not be_success
      end
    end



  end

  describe "GET 'notice'" do
    before(:each) do
      @notice = FactoryGirl.create :notice
      sign_in user
    end

    it "should redirect to the notice path and close it" do
      get :notice, :id => @notice.id
      response.should redirect_to(@notice.path)
      @notice.reload.open.should be false
    end

  end

end
