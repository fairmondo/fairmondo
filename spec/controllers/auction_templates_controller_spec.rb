require 'spec_helper'

describe AuctionTemplatesController do

  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  def valid_attributes
    auction_attributes = FactoryGirl::attributes_for(:auction, :categories_and_ancestors => [FactoryGirl.create(:category)])
    template_attributes = FactoryGirl.attributes_for(:auction_template)
    template_attributes[:auction_attributes] = auction_attributes
    template_attributes 
  end
  
  let :valid_update_attributes do
    attrs = valid_attributes
    attrs[:auction_attributes].merge!(:id => @auction_template.auction.id)
    attrs
  end

  describe "GET new" do
    it "assigns a new auction_template as @auction_template" do
      get :new, {}
      assigns(:auction_template).should be_a_new(AuctionTemplate)
    end
  end

  describe "GET edit" do
    
    before :each do
      @auction_template = FactoryGirl.create(:auction_template, :user => @user)
    end
    
    it "assigns the requested auction_template as @auction_template" do
      get :edit, {:id => @auction_template.to_param}
      assigns(:auction_template).should eq(@auction_template)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new AuctionTemplate" do
        expect {
          post :create, {:auction_template => valid_attributes}
        }.to change(AuctionTemplate, :count).by(1)
      end

      it "assigns a newly created auction_template as @auction_template" do
        post :create, {:auction_template => valid_attributes}
        assigns(:auction_template).should be_a(AuctionTemplate)
        assigns(:auction_template).should be_persisted
      end

      it "redirects to the collection" do
        post :create, {:auction_template => valid_attributes}
        response.should redirect_to(user_url(@user, :anchor => "my_auction_templates"))
      end
    end

# why does the devise test helper expect a user_auction_templates_url?
    # describe "with invalid params" do
      # it "assigns a newly created but unsaved auction_template as @auction_template" do
        # # Trigger the behavior that occurs when invalid params are submitted
        # AuctionTemplate.any_instance.stub(:save).and_return(false)
        # post :create, {:auction_template => {}}
        # assigns(:auction_template).should be_a_new(AuctionTemplate)
      # end
# 
      # it "re-renders the 'new' template" do
        # # Trigger the behavior that occurs when invalid params are submitted
        # AuctionTemplate.any_instance.stub(:save).and_return(false)
        # post :create, {:auction_template => {}}
        # response.should render_template("new")
      # end
    # end
  end

  describe "PUT update" do
    
    before :each do
      @auction_template = FactoryGirl.create(:auction_template, :user => @user)
    end
    
    describe "with valid params" do  
      
      it "updates the requested auction_template" do
        put :update, {:id => @auction_template.to_param, "auction_template" => {"auction_attributes" => {"title" => "updated Title", "id" => @auction_template.auction.id}}}
        @auction_template.reload
        @auction_template.auction.title.should == "updated Title"
      end

      it "assigns the requested auction_template as @auction_template" do
        put :update, {:id => @auction_template.to_param, :auction_template => valid_update_attributes}
        assigns(:auction_template).should eq(@auction_template)
      end

      it "redirects to the collection" do
        put :update, {:id => @auction_template.to_param, :auction_template => valid_update_attributes}
        response.should redirect_to(user_url(@user, :anchor => "my_auction_templates"))
      end
    end

# why does the devise test helper expect a user_auction_templates_url?
    # describe "with invalid params" do
      # it "assigns the auction_template as @auction_template" do
        # AuctionTemplate.any_instance.stub(:save).and_return(false)
        # put :update, {:id => @auction_template.to_param, "auction_template" => {"auction_attributes" => {"title" => "updated Title"}}}
        # assigns(:auction_template).should eq(@auction_template)
      # end

      # it "re-renders the 'edit' template" do
        # AuctionTemplate.any_instance.stub(:save).and_return(false)
        # put :update, {:id => @auction_template.to_param, :auction_template => {}}
        # response.should render_template("edit")
      # end
    # end    
  end

  describe "DELETE destroy" do
     
    before :each do
      @auction_template = FactoryGirl.create(:auction_template, :user => @user)
    end
    
    it "destroys the requested auction_template" do
      expect {
        delete :destroy, {:id => @auction_template.to_param}
      }.to change(AuctionTemplate, :count).by(-1)
    end

    it "redirects to the auction_templates list" do
      delete :destroy, {:id => @auction_template.to_param}
      response.should redirect_to(user_url(@user, :anchor => "my_auction_templates"))
    end
  end

end
