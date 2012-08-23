require 'spec_helper'

describe ImagesController do
  render_views

  describe "POST 'create'" do

    before :each do
      @auction = FactoryGirl.create(:auction)
      @image_attr = Factory.attributes_for(:image, :auction_id => @auction.id)
      sign_in @auction.seller
    end

    it "should be successful" do
      post :create, :image => @image_attr
      response.should redirect_to(@auction)
    end

    it "should increase number of images" do
      lambda do
       post :create, :image => @image_attr
      end.should change(Image, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do
    before :each do
      @image = FactoryGirl.create(:image)
      sign_in @image.auction.seller
    end

    it "should be successful" do
      delete :destroy, :id => @image
      response.should redirect_to(@image.auction)
    end

    it "should delete an image" do
      lambda do
          delete :destroy, :id => @image
        end.should change(Image, :count).by(-1)
    end
  end
end