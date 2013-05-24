require "spec_helper"

describe ArticlesHelper do

  describe "#get_category_tree(leaf_category)" do
    it "should return an array with parent categories of a given child category " do
      parent_category = FactoryGirl.create :category
      child_category = FactoryGirl.create :category, parent: parent_category

      helper.get_category_tree(child_category).should eq [parent_category, child_category]
    end
  end

  describe "#title_image" do
    before do
      @article = FactoryGirl.create :article
      @img1 = FactoryGirl.create :image
      @img2 = FactoryGirl.create :image
      @article.images = [@img1, @img2]
      helper.stub!(:resource).and_return( @article)
    end

    it "should return the image defined by params" do
      params[:image] = @img2.id
      helper.title_image.should eq @img2
    end

    it "should return the first image if no params are given" do
      params = nil
      helper.title_image.should eq @img1
    end
  end

  # describe "#category_shift(level)" do
  #   it "should return the correct css" do
  #     helper.category_shift(1).should eq 'padding-left:10px;'
  #   end
  # end
end
