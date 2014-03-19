#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
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



  describe "options_format_for (type, method, css_classname)" do
     before do
      helper.stub(:resource).and_return FactoryGirl.create :article, :transport_type2 => true, :transport_type2_price => 3, :transport_type2_provider => "test"
     end

    it "should return 'kostenfrei'" do
      helper.options_format_for("transport","pickup","").should match(/(kostenfrei)/)
    end

    it "should return 'zzgl.'" do
      helper.options_format_for("transport","type2","").should match(/zzgl. /)
    end

  end

  describe "#fair_alternative_to", search: true do
      context "find fair alternative", setup: true do
        before(:all) do
          setup
          @normal_article =  FactoryGirl.create :article ,:category1, :title => "weisse schockolade"
          @other_normal_article = FactoryGirl.create :article,:category2 , :title => "schwarze schockolade aber anders"
          @not_related_article = FactoryGirl.create :article,:category1 , :title => "schuhcreme"
          @fair_article = FactoryGirl.create :article, :simple_fair ,:category1 , :title => "schwarze fairtrade schockolade"
          @other_fair_article = FactoryGirl.create :article, :simple_fair ,:category2 , :title => "weisse schockolade"
          Sunspot.commit
        end

        it "should find a fair alternative in with the similar title and category" do
          (helper.find_fair_alternative_to @normal_article).should eq @fair_article
        end

        it "should raise sunspot error" do
          Article.stub(:search).and_raise(Errno::ECONNREFUSED)
          (helper.find_fair_alternative_to @normal_article).should eq nil
        end


        it "should not find a fair alternative with a similar title and an other category" do
          (helper.find_fair_alternative_to @other_normal_article).should_not eq @fair_article
        end

        it "should prefer the same category over matches in the title" do
          (helper.find_fair_alternative_to @other_normal_article).should eq @other_fair_article
        end

        it "should not find an unrelated article" do
          (helper.find_fair_alternative_to @not_related_article).should eq nil
        end

      end
      context "dont find fair alternative in categories with misc content", setup: true do
        before(:all) do
          setup
          @other_category  = Category.other_category.first || FactoryGirl.create(:category,:name => "Sonstiges")
          @normal_article =  FactoryGirl.create :article , :title => "weisse schockolade",:categories_and_ancestors => [@other_category,FactoryGirl.create(:category)]
          @fair_article = FactoryGirl.create :article, :simple_fair,:title => "weisse schockolade",:categories_and_ancestors => [@other_category]
          Sunspot.commit
        end

        it "sould not find the other article" do
          (helper.find_fair_alternative_to @normal_article).should eq nil
        end

      end


  end

  describe "#rate_article" do

     it "should return 3 on fair article" do
        @article = FactoryGirl.create :article, :simple_fair
        (helper.rate_article  @article).should eq 3
     end

     it "should return 2 on eco article" do
         @article = FactoryGirl.create :article, :simple_ecologic
         (helper.rate_article  @article).should eq 2
     end

      it "should return 1 on old article" do
         @article =  FactoryGirl.create :second_hand_article
        (helper.rate_article  @article).should eq 1
     end

     it "should return 0 on normal article" do
        @article =  FactoryGirl.create :no_second_hand_article
        (helper.rate_article  @article).should eq 0
     end

     it "should return 0 on nil article" do
        @article =  nil
        (helper.rate_article  @article).should eq 0
     end

  end



  # describe "#category_shift(level)" do
  #   it "should return the correct css" do
  #     helper.category_shift(1).should eq 'padding-left:10px;'
  #   end
  # end
end
