require "spec_helper"

describe 'FairAlternative' do
  include RSpec::Rails::HelperExampleGroup

  describe "#find_for", search: true do
    context "find fair alternative", setup: true do
      before(:all) do
        setup
        @normal_article =  FactoryGirl.create :article ,:category1, :title => "weisse schockolade"
        @other_normal_article = FactoryGirl.create :article,:category2 , :title => "schwarze schockolade aber anders"
        @not_related_article = FactoryGirl.create :article,:category1 , :title => "schuhcreme"
        @fair_article = FactoryGirl.create :article, :simple_fair ,:category1 , :title => "schwarze fairtrade schockolade"
        @other_fair_article = FactoryGirl.create :article, :simple_fair ,:category2 , :title => "weisse schockolade"
        Article.index.refresh
      end

      it "should find a fair alternative in with the similar title and category" do
        FairAlternative.find_for(@normal_article).id.should eq @fair_article.id.to_s
      end

      it "should raise search error" do
        Article.stub(:search).and_raise(Errno::ECONNREFUSED)
        FairAlternative.find_for(@normal_article).should eq nil
      end


      it "should not find a fair alternative with a similar title and an other category" do
        FairAlternative.find_for(@other_normal_article).id.should_not eq @fair_article.id.to_s
      end

      it "should prefer the same category over matches in the title" do
        FairAlternative.find_for(@other_normal_article).id.should eq @other_fair_article.id.to_s
      end

      it "should not find an unrelated article" do
        FairAlternative.find_for(@not_related_article).should eq nil
      end

    end
    context "dont find fair alternative in categories with misc content", setup: true do
      before(:all) do
        setup
        @other_category  = Category.other_category.first || FactoryGirl.create(:category,:name => "Weitere")
        @normal_article =  FactoryGirl.create :article , :title => "weisse schockolade",:categories => [@other_category,FactoryGirl.create(:category)]
        @fair_article = FactoryGirl.create :article, :simple_fair,:title => "weisse schockolade",:categories => [@other_category]
        Article.index.refresh
      end

      it "sould not find the other article" do
        @alternative = FairAlternative.find_for(@normal_article)
        @alternative.should eq nil
      end

    end


  end

  describe "#rate_article" do

    it "should return 3 on fair article" do
      @article = FactoryGirl.create :article, :simple_fair
      FairAlternative.send(:rate_article,  @article).should eq 3
    end

    it "should return 2 on eco article" do
      @article = FactoryGirl.create :article, :simple_ecologic
      FairAlternative.send(:rate_article,  @article).should eq 2
    end

    it "should return 1 on old article" do
      @article =  FactoryGirl.create :second_hand_article
      FairAlternative.send(:rate_article,  @article).should eq 1
    end

    it "should return 0 on normal article" do
      @article =  FactoryGirl.create :no_second_hand_article
      FairAlternative.send(:rate_article,  @article).should eq 0
    end

    it "should return 0 on nil article" do
      @article =  nil
      FairAlternative.send(:rate_article,  @article).should eq 0
    end

  end
end
