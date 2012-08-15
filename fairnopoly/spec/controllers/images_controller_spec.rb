require 'spec_helper'

describe ImagesController do
  render_views

  describe "POST 'create'" do

    it "should be successful" do
      Image.create
      response.should be_success
    end

    it "should increase number of images" do
      lambda do
        @image = FactoryGirl.create(:image)
      end.should change(Image, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do
    before :each do
      @image = FactoryGirl.create(:image)
    end

    it "should delete an image" do
      lambda do
          @image.destroy
        end.should change(Image, :count).by(-1)
    end
  end
end
