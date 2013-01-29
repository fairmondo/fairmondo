require 'spec_helper'

describe AuctionsController do
  render_views

  describe "GET 'index" do
    
    describe "search" do
      
      before :each do
        @auction  = FactoryGirl.create(:auction, :title => "muscheln")
      end
      
      it "should find the auction with title 'muscheln' when searching for muscheln" do
        get :index, :auction => {:title => "muscheln" }
        controller.instance_variable_get(:@auctions).should == [@auction]
      end
      
      it "should find the auction with title 'muscheln' when searching for muschel" do
        get :index, :auction => {:title => "muschel" }
        controller.instance_variable_get(:@auctions).should == [@auction]
      end
    
    end
    
    describe "for non-signed-in users" do

      it "should be successful" do
        get :index
        response.should be_successful
      end

      it "should render the :index view" do
        get :index
        response.should render_template :index
      end
    end
    
    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        @auction = FactoryGirl.create(:auction)
        sign_in @user
      end

      it "should be successful" do
        get :index
        response.should render_template :index
      end

      it "should render the :index view" do
        get :index
        response.should render_template :index
      end

      it "should be successful" do
        get :index, :condition => "true"
        response.should be_success
      end

      it "should be successful" do
        get :index, :selected_category_id => Category.all.sample.id
        response.should be_success
      end

      it "should be successful" do
        get :index, :auction => {:title => "true" }
        response.should be_success
      end
    end
  end

  describe "GET 'show" do

    before :each do
      @user = FactoryGirl.create(:user)
      @auction  = FactoryGirl.create(:auction)
    end
    
    describe "for non-signed-in users" do

      it "should be successful" do
        get :show, id: @auction
        response.should be_success
      end

      it "should render the :show view" do
        get :show, id: @auction
        response.should render_template :show
      end
    end

    describe "for signed-in users" do

    it "should be successful" do
        get :show, id: @auction
        response.should render_template :show
      end

      it "should render the :show view" do
        sign_in @user
        get :show, id: @auction
        response.should render_template :show
      end

      it "should create an image for the auction" do
        @auction = FactoryGirl.create(:auction)
        sign_in @auction.seller
        get :show, id: @auction
        @image = controller.instance_variable_get(:@image)
        @image.auction.should eq @auction
      end

      it "should assign a title image" do
        @image = FactoryGirl.create(:image)
        sign_in @image.auction.seller
        get :show, id: @image.auction, :image => @image
        @image.should eq controller.instance_variable_get(:@title_image)
      end
    end
  end

  describe "GET 'new'" do

    describe "for non-signed-in users" do

      it "should require login" do
        get :new
        response.should redirect_to(new_user_session_path)
      end
      
    end

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "should render the :new view" do
        get :new
        response.should render_template :new
      end
    end
  end

  describe "GET 'edit'" do

    describe "for non-signed-in users" do

      it "should deny access" do
        @auction = FactoryGirl.create(:auction)
        get :edit, :id => @auction.id
        response.should redirect_to(new_user_session_path)
      end
      
    end

    describe "for signed-in users" do
      
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end
      
      context 'his auctions' do
        before :each do
          @auction = FactoryGirl.create(:auction, :seller => @user)
        end

        it "should be successful for the seller" do
          get :edit, :id => @auction.id
          response.should be_success
        end
      end
      
      it "should not be able to edit other users auctions" do
        @auction = FactoryGirl.create(:auction)
        expect{
          get :edit, :id => @auction
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "report" do

    before :each do
      @user = FactoryGirl.create(:user)
      @auction = FactoryGirl.create(:auction)
      sign_in @user
    end

    it "reports an auction" do
      get :report, :id => @auction
      response.should redirect_to @auction
    end
    
  end

  describe "POST 'create'" do

    before :each do
      @user = FactoryGirl.create(:user)
      @auction_attrs = (FactoryGirl::attributes_for(:auction))
    end

    describe "for non-signed-in users" do
      it "should not create an auction" do
        lambda do
          post :create, :auction => @auction_attrs
        end.should_not change(Auction, :count)
      end
    end

    describe "for signed-in users" do

      before :each do
        sign_in @user
      end

      it "should create an auction" do
        lambda do
          post :create, :auction => @auction_attrs
        end.should change(Auction, :count).by(1)
      end
    end
  end


  describe "PUT 'update'" do

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        @auction = FactoryGirl::create(:auction, :seller => @user)
        @auction_attrs = FactoryGirl::attributes_for(:auction)
        sign_in @user
      end

      it "should not update the auction" do
        put :update, id: @auction.id
        response.should render_template :edit
      end

      it "should update the auction with new information" do
        put :update, :id => @auction.id, :auction => @auction_attrs
        response.should redirect_to @auction
      end

      it "changes the auctions informations" do
        put :update, :id => @auction.id, :auction => @auction_attrs
        response.should redirect_to @auction
        controller.instance_variable_get(:@auction).title.should eq @auction_attrs[:title]
      end
    end
  end
end