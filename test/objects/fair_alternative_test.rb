require "test_helper"

describe 'FairAlternative' do

  describe "#find_for" do
    it "finds fair alternatives" do
      TireTest.on
      Article.index.delete
      Article.create_elasticsearch_index
      @normal_article =  FactoryGirl.create :article ,:category1, :title => "weisse schockolade"
      @other_normal_article = FactoryGirl.create :article,:category2 , :title => "schwarze schockolade aber anders"
      @not_related_article = FactoryGirl.create :article,:category1 , :title => "schuhcreme"
      @fair_article = FactoryGirl.create :article, :simple_fair ,:category1 , :title => "schwarze fairtrade schockolade"
      @other_fair_article = FactoryGirl.create :article, :simple_fair ,:category2 , :title => "weisse schockolade"
      Article.index.refresh

      FairAlternative.find_for(@normal_article).id.must_equal @fair_article.id.to_s

      FairAlternative.find_for(@other_normal_article).id.wont_equal @fair_article.id.to_s

      FairAlternative.find_for(@other_normal_article).id.must_equal @other_fair_article.id.to_s

      FairAlternative.find_for(@not_related_article).must_equal nil
      TireTest.off

    end

    it "handles errors" do
      Article.stubs(:search).raises(Errno::ECONNREFUSED)
      FairAlternative.find_for(@normal_article).must_equal nil
    end

    it "doesnt find fair alternative in categories with misc content" do
      TireTest.on
      Article.index.delete
      Article.create_elasticsearch_index

      @other_category  = Category.other_category.first || FactoryGirl.create(:category,:name => "Weitere")
      @normal_article =  FactoryGirl.create :article , :title => "weisse schockolade",:categories => [@other_category,FactoryGirl.create(:category)]
      @fair_article = FactoryGirl.create :article, :simple_fair,:title => "weisse schockolade",:categories => [@other_category]
      Article.index.refresh

      @alternative = FairAlternative.find_for(@normal_article)
      @alternative.must_equal nil
      TireTest.off
    end
  end

  describe "#rate_article" do

    it "should return 3 on fair article" do
      @article = FactoryGirl.create :article, :simple_fair
      FairAlternative.send(:rate_article,  @article).must_equal 3
    end

    it "should return 2 on eco article" do
      @article = FactoryGirl.create :article, :simple_ecologic
      FairAlternative.send(:rate_article,  @article).must_equal 2
    end

    it "should return 1 on old article" do
      @article =  FactoryGirl.create :second_hand_article
      FairAlternative.send(:rate_article,  @article).must_equal 1
    end

    it "should return 0 on normal article" do
      @article =  FactoryGirl.create :no_second_hand_article
      FairAlternative.send(:rate_article,  @article).must_equal 0
    end

    it "should return 0 on nil article" do
      @article =  nil
      FairAlternative.send(:rate_article,  @article).must_equal 0
    end

  end
end
