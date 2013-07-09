#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
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
      helper.stub(:resource).and_return( @article)
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
