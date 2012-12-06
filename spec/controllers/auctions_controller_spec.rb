require 'spec_helper'

describe AuctionsController do
  render_views

  describe "GET 'index" do
    
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
        get :index, :q => "true"
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

      it "should be successful" do
        get :new
        response.should be_success
      end

      it "should render the :new view" do
        get :new
        response.should render_template :new
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

  #    it "should deny access" do
  #      get :edit
  #      response.should redirect_to(new_user_session_path)
  #    end
  #  end

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        @auction = FactoryGirl.create(:auction)
        sign_in @user
      end

        it "should be successful" do
          auction = FactoryGirl.create(:auction)
          get :edit, :id => auction
          response.should be_success
        end
        end

      it "should be editable" do
        @auction = FactoryGirl.create(:auction)
        sign_in @auction.seller
        get :edit, :id => @auction
        response.should be_success
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

  describe "finalize" do

    describe "for non-signed-in users" do

      it "should deny access" do
        get :finalize
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "for signed-in users" do

      it "should finalize the prepared auction" do
        @auction = FactoryGirl.create(:auction)
        sign_in @auction.seller
        controller.finalize
        response.should be_success
      end
    end
  end

  describe "POST 'create'" do

    describe "for non-signed-in users" do

      end
    end

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        @auction_attrs = (FactoryGirl::attributes_for(:auction))
        sign_in @user
      end

    it "should not create an auction" do
        lambda do
          post :create, :auction => @auction_attrs
        end.should change(Auction, :count).by(0)
      end
    end
  end


  describe "PUT 'update'" do

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        @auction = FactoryGirl::create(:auction)
        sign_in @user
      end

     it "should not update the auction" do
        put :update, id: @auction
        response.should render_template :edit
     end

     it "should update the auction with new information" do
        @auction_attrs = FactoryGirl::attributes_for(:auction)
        put :update, :id => @auction, :auction => @auction_attrs
        response.should redirect_to @auction
     end

     it "changes the auctions informations" do
       @auction_attrs = FactoryGirl::attributes_for(:auction)
       put :update, :id => @auction, :auction => @auction_attrs
       response.should redirect_to @auction
       controller.instance_variable_get(:@auction).title.should eq @auction_attrs[:title]
     end
    end
  end
end