require 'spec_helper'

describe Article do

  let(:article) { FactoryGirl::create(:article) }
  subject { article }

  it {should have_many :images}

  it {should belong_to :seller}
  it {should have_many :categories}

  it "should return the title image" do
    image = FactoryGirl.create(:image, :article => article)
    article.title_image
  end

  describe "with_user_id scope" do
    before do
      @article_with_id = FactoryGirl.create(:article)
      @article_without_id = FactoryGirl.create(:article).user_id = nil
    end

    it "should return all articles with a user_id when called with 'true'" do
      results = Article.with_user_id(true)
      results.should include(@article_with_id)
      results.should_not include(@article_without_id)
    end

    it "should return all articles with a specific user_id when called with an integer" do
      article_with_correct_id = FactoryGirl.create(:article)
      results = Article.with_user_id(article_with_correct_id.user_id)
      results.should include(article_with_correct_id)
      results.should_not include(@article_with_id)
      results.should_not include(@article_without_id)
    end
  end

  describe "Article::Initial" do
    it "should rescue MissingAttributeErrors" do
      article.stub(:new_record?) { raise ActiveModel::MissingAttributeError }
      article.initialize_values.should_not raise_error(ActiveModel::MissingAttributeError)
    end
  end

  describe "Article::FeesAndDonations" do
    describe "friendly_percent_calculated" do
      it "should call friendly_percent_result" do
        article.should_receive :friendly_percent_result
        article.friendly_percent_calculated
      end
    end
    describe "fee_percentage" do
      it "should return the fair percentage when article.fair" do
        article.fair = true
        article.send('fee_percentage').should == 0.03
      end

      it "should return the default percentage when !article.fair" do
        article.send('fee_percentage').should == 0.06
      end
    end
  end

  describe "Article::Attributes" do
    it "should throw an error if default_transport_selected isn't able to call the transport function" do
      article.default_transport.should be_true
      article.stub(:send).and_return false
      article.default_transport_selected
      article.errors[:default_transport].should == [I18n.t("errors.messages.invalid_default_transport")]
    end

    it "should throw an error if default_payment_selected isn't able to call the payment function" do
      article.default_payment.should be_true
      article.stub(:send).and_return false
      article.default_payment_selected
      article.errors[:default_payment].should == [I18n.t("errors.messages.invalid_default_payment")]
    end
  end

  describe "Article::Commendation" do
    describe "with_commendation scope" do
      it "should be unscoped without commendations" do
        Article.with_commendation.should == Article.scoped
      end
      it "should return the correct scope with given commendations" do
        article_without_commendations = FactoryGirl.create(:article)
        article_fair = FactoryGirl.create(:article, fair: true, fair_kind: :fair_trust)
        article_ecologic = FactoryGirl.create(:article, ecologic: true, ecologic_kind: :ecologic_seal, ecologic_seal: :bio_siegel)
        article_fair_ecologic = FactoryGirl.create(:article, fair: true, fair_kind: :fair_trust, ecologic: true, ecologic_kind: :ecologic_seal, ecologic_seal: :bio_siegel)

        results = Article.with_commendation :fair, :ecologic
        results.should include(article_fair_ecologic, article_fair, article_ecologic)
        results.should_not include(article_without_commendations)
      end
    end
  end

  describe "Article::Categories" do
    describe "size_validator" do
      it "should validate size of categories" do
        article_0cat = FactoryGirl.build :article
        article_0cat.categories = []
        article_1cat = FactoryGirl.build :article
        article_2cat = FactoryGirl.build :article, :with_child_category
        article_3cat = FactoryGirl.build :article, :with_3_categories

        article_0cat.should_not be_valid
        article_1cat.should be_valid
        article_2cat.should be_valid
        article_3cat.should_not be_valid
      end
    end

    describe "with_exact_category_id scope" do
      it "should be unscoped without category_id" do
        Article.with_exact_category_id.should == Article.scoped
      end
      it "should return all articles of a given category" do
        article1_cat1 = FactoryGirl.create :article, :category1
        article2_cat1 = FactoryGirl.create :article, :category1
        article1_cat2 = FactoryGirl.create :article, :category2

        results = Article.with_exact_category_id 1
        results.should include article1_cat1, article2_cat1
        results.should_not include article1_cat2
      end
    end

    describe "with_exact_category_ids scope" do
      it "should return all articles of multiple given categories" do
        article_cat1 = FactoryGirl.create :article, :category1
        article_cat2 = FactoryGirl.create :article, :category2
        article_cat3 = FactoryGirl.create :article, :category3

        results = Article.with_exact_category_ids [1, 2]
        results.should include article_cat1, article_cat2
        results.should_not include article_cat3
      end
    end

    describe "with_category_or_descendant_ids" do
      it "should do something" do
        article_cat1 = FactoryGirl.create :article, :category1
        article_cat2 = FactoryGirl.create :article, :category2
        article_childcat = FactoryGirl.create :article, :with_child_category

        results = Article.with_category_or_descendant_ids [1, article_childcat.categories[0].id]
        results.should include article_cat1, article_childcat
        results.should_not include article_cat2
      end
    end
  end
end