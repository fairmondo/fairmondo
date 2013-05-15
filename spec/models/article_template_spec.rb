require 'spec_helper'

describe ArticleTemplate do
  let(:article_template) { FactoryGirl.create(:article_template) }
  subject { article_template }

  it "should have a valid factory" do
    should be_valid
  end

  it {should validate_presence_of :name}
  it {should validate_uniqueness_of(:name).scoped_to(:user_id)}
  it {should validate_presence_of :user_id}

  it {should belong_to :user}
  it {should have_one(:article).dependent(:destroy)}
  it {should accept_nested_attributes_for :article}

  describe "articles_article_template validation" do
    before do
      article_template = FactoryGirl.build(:article_template)
    end

    it "should return an article template" do
      article_template.send("articles_article_template").should eq article_template
    end

    it "should throw an error when no article is present" do
      article_template.article = nil
      article_template.should_not be_valid
    end
  end


  describe "deep_article_attributes method" do
    it "should return a hash with attributes of the underlying article" do
      result = article_template.deep_article_attributes
      result.class.should eq Hash
      result['id'].should eq article_template.article.id
    end
  end

  describe "non_assignable_values method" do
    its(:non_assignable_values) { should eq ["id", "created_at", "updated_at", "article_id"] }
  end
end
