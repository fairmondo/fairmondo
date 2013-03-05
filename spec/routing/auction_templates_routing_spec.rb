require "spec_helper"

describe AuctionTemplatesController do
  describe "routing" do

    it "routes to #new" do
      get("/auction_templates/new").should route_to("auction_templates#new")
    end

    it "routes to #edit" do
      get("/auction_templates/1/edit").should route_to("auction_templates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/auction_templates").should route_to("auction_templates#create")
    end

    it "routes to #update" do
      put("/auction_templates/1").should route_to("auction_templates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/auction_templates/1").should route_to("auction_templates#destroy", :id => "1")
    end

  end
end
