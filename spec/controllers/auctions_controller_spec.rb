require 'spec_helper'

describe AuctionsController do
  render_views
  include CategorySeedData

  describe "GET 'index" do
    
    describe "search", :search => true do
      
      before :each do
        setup_categories
        @vehicle_category = Category.find_by_name!("Fahrzeuge")
        @auction  = FactoryGirl.create(:second_hand_auction, :title => "muscheln", :categories_and_ancestors => @vehicle_category.self_and_ancestors.map(&:id) )
        Sunspot.commit
      end
      
      it "should find the auction with title 'muscheln' when searching for muscheln" do
        get :index, :auction => {:title => "muscheln" }
        controller.instance_variable_get(:@auctions).should == [@auction]
      end
      
      it "should find the auction with title 'muscheln' when searching for muschel" do
        get :index, :auction => {:title => "muschel" }
        controller.instance_variable_get(:@auctions).should == [@auction]
      end
      
      context "when filtering by categories" do
        before :each do
          @hardware_category = Category.find_by_name!("Hardware")
          @hardware_auction  = FactoryGirl.create(:second_hand_auction, :title => "muscheln 2", :categories_and_ancestors => @hardware_category.self_and_ancestors.map(&:id))
          Sunspot.commit
        end
        
        it "should find the auction in category 'Hardware' when filtering for 'Hardware'" do
          @electronic_category = Category.find_by_name!("Elektronik")
          get :index, :auction => {:categories_and_ancestors => @hardware_category.self_and_ancestors.map(&:id)}
          controller.instance_variable_get(:@auctions).should == [@hardware_auction]
        end
        
        it "should find the auction in category 'Hardware' when filtering for the ancestor 'Elektronik'" do
          @electronic_category = Category.find_by_name!("Elektronik")
          get :index, :auction => {:categories_and_ancestors => @electronic_category.self_and_ancestors.map(&:id)}
          controller.instance_variable_get(:@auctions).should == [@hardware_auction]
        end
        
        it "should not find the auction in category 'Hardware' when filtering for 'Software'" do
          @software_category = Category.find_by_name!("Software")
          get :index, :auction => {:categories_and_ancestors => @software_category.self_and_ancestors.map(&:id)}
          controller.instance_variable_get(:@auctions).should == []
        end
        
        context "#categories_with_ancestors" do
          context "when passing a category_id without its ancestors" do
            it "should remove the orphan descendants from the passed subtree" do
              @audio_category = Category.find_by_name!("Audio & HiFi")
              get :index, :auction => {:categories_and_ancestors => @audio_category.self_and_ancestors.map(&:id) + [@hardware_category.id] }
              controller.instance_variable_get(:@auctions).should == []
            end
          end
        end
        
        context "and searching for 'muscheln'" do 
          
          it "should find all auctions with title 'muscheln' with an empty categories filter" do
            get :index, :auction => {:categories_and_ancestors => [], :title => "muscheln"}
            controller.instance_variable_get(:@auctions).should == [@auction, @hardware_auction]
          end
          
          it "should chain both filters" do
            get :index, :auction => {:categories_and_ancestors => @hardware_category.self_and_ancestors.map(&:id), :title => "muscheln"}
            controller.instance_variable_get(:@auctions).should == [@hardware_auction]
          end
          
          context "and filtering for condition" do
            
            before :each do
              @no_second_hand_auction = FactoryGirl.create(:no_second_hand_auction, :title => "muscheln 3", :categories_and_ancestors => @hardware_category.self_and_ancestors.map(&:id))
              Sunspot.commit 
            end
            
            it "should find all auctions with title 'muscheln' with empty condition and category filter" do
              get :index, :auction => {:categories_and_ancestors => [], :title => "muscheln"}
              controller.instance_variable_get(:@auctions).should == [@auction, @hardware_auction, @no_second_hand_auction]
            end
            
            it "should chain all filters" do
              get :index, :auction => {:categories_and_ancestors => @hardware_category.self_and_ancestors.map(&:id), :title => "muscheln", :condition => "old"}
              controller.instance_variable_get(:@auctions).should == [@hardware_auction]
            end
            
          end
          
        end
        
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
        @image = controller.instance_variable_get(:@title_image)
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
          
          #cant use editable_auction factory due to defaultscope 
          @auction.active = false
          @auction.locked = false
          @auction.save
        end

        it "should be successful for the seller" do
          get :edit, :id => @auction.id
          response.should be_success
        end
      end
      
      it "should not be able to edit other users auctions" do
        @auction = FactoryGirl.create(:editable_auction)
       
        expect{
          get :edit, :id => @auction
        }.to raise_error(Pundit::NotAuthorizedError)
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
      @auction_attrs = FactoryGirl::attributes_for(:auction, :categories_and_ancestors => [FactoryGirl.create(:category)])
      @auction_attrs[:transaction_attributes]= FactoryGirl.attributes_for(:transaction)
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
        end.should change(Auction.unscoped, :count).by(1)
      end
      
      it "should not raise an error for very high quantity values" do
        post :create, :auction => @auction_attrs.merge(:quantity => "100000000000000000000000")
        response.should render_template :new
        response.response_code.should == 200
      end
      
    end
  end


  describe "PUT 'update'" do

    describe "for signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        @auction = FactoryGirl::create(:inactive_auction, :seller => @user)
        @auction_attrs = FactoryGirl::attributes_for(:auction, :categories_and_ancestors => [FactoryGirl.create(:category)])
        @auction_attrs.delete(:seller)
        @auction_attrs[:transaction_attributes]= FactoryGirl.attributes_for(:transaction)
        sign_in @user
      end

      it "should update the auction with new information" do
        put :update, :id => @auction.id, :auction => @auction_attrs
        response.should redirect_to @auction.reload
      end

      it "changes the auctions informations" do
        put :update, :id => @auction.id, :auction => @auction_attrs
        response.should redirect_to @auction.reload
        controller.instance_variable_get(:@auction).title.should eq @auction_attrs[:title]
      end
    end
  end
end