require 'spec_helper'

describe AuctionsController do
  
  describe "authenticated user" do
    before :each do
      @user = FactoryGirl::create(:user)
      sign_in @user
    end
    
    it "should be logged in" do
      controller.should be_signed_in
    end
    
  end
  
  describe "guest user" do
    
    it "should be a guest" do
      controller.should_not be_signed_in
    end
    
    describe "GET 'show'" do
        it "should render the :show view" do
          category = FactoryGirl::create(:category)
          auction = FactoryGirl::create(:auction)
          get :show, id: auction
          response.should render_template :show
        end
      end
      
      describe "GET 'index'" do
        it "should render the :index view" do
          get :index
          response.should render_template :index
        end
      end
      
      
     describe "GET 'new'" do
        it "should render the :new view" do
          get :new
          response.should render_template :new
        end
      end
    
      describe "GET 'create'" do
        it "should render the :create view" do
          get :create
          response.should render_template :new
        end
      end
  end

end
