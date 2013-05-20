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

  end

end
