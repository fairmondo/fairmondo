require "spec_helper"

describe ArticleTemplatesController do
  describe "routing" do

    it "routes to #new" do
      get("/article_templates/new").should route_to("article_templates#new")
    end

    it "routes to #edit" do
      get("/article_templates/1/edit").should route_to("article_templates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/article_templates").should route_to("article_templates#create")
    end

    it "routes to #update" do
      put("/article_templates/1").should route_to("article_templates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/article_templates/1").should route_to("article_templates#destroy", :id => "1")
    end

  end
end
