require "spec_helper"

module Tinycms
  describe ContentsController do
    describe "routing" do
      
      before(:each) { @routes = Tinycms::Engine.routes }
  
      it "engine root routes to #index" do
        get("/").should route_to("tinycms/contents#index")
      end
      
      it "routes to #index" do
        get("/contents").should route_to("tinycms/contents#index")
      end
      
      it "routes to #new" do
        get("/contents/new").should route_to("tinycms/contents#new")
      end
  
      it "routes to #show" do
        get("/contents/1").should route_to("tinycms/contents#show", :id => "1")
      end
  
      it "routes to #edit" do
        get("/contents/1/edit").should route_to("tinycms/contents#edit", :id => "1")
      end
  
      it "routes to #create" do
        post("/contents").should route_to("tinycms/contents#create")
      end
  
      it "routes to #update" do
        put("/contents/1").should route_to("tinycms/contents#update", :id => "1")
      end
  
      it "routes to #destroy" do
        delete("/contents/1").should route_to("tinycms/contents#destroy", :id => "1")
      end
  
    end
  end
end