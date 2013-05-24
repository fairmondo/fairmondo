require 'spec_helper'

describe ArticleObserver do

  let(:article) { FactoryGirl.create(:article) }
  subject { article }

  describe "Category Proposals" do
      it "should send an email when a category_proposal was given" do
        article.category_proposal = 'foo'
        ArticleMailer.should_receive(:category_proposal).with('foo').and_call_original
        observer = ArticleObserver.instance
        observer.after_save(article)
      end
    end
end