require 'spec_helper'

describe Article do

  let(:article) { FactoryGirl::create(:article) }
  subject { article }

  it {should have_and_belong_to_many :images}

  it {should belong_to :seller}
  it {should have_and_belong_to_many :categories}

  it "should return the title image" do
    image = FactoryGirl.create(:image)
    article.images << image
    article.title_image
  end



  describe "Article::Initial" do
    it "should rescue MissingAttributeErrors" do
      article.stub(:new_record?) { raise ActiveModel::MissingAttributeError }
      article.initialize_values.should_not raise_error(ActiveModel::MissingAttributeError)
    end
  end

  describe "Article::FeesAndDonations" do

    #at the moment we do not have friendly percentece any more
    #describe "friendly_percent_calculated" do
      #it "should call friendly_percent_result" do
        #article.should_receive :friendly_percent_result
        #article.friendly_percent_calculated
      #end
    #end

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



  end
end