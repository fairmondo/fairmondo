require "spec_helper"

describe ArticleMailer do
  describe "report_article" do
    let(:article) { FactoryGirl.create(:article) }
    let(:mail) { ArticleMailer.report_article(article,"text") }

    it "renders the subject" do
      mail.subject.should have_content("Article reported")
    end

    it "contains the article id" do
      mail.subject.should eq("Article reported with ID: " + article.id.to_s)
    end
  end

  describe "category_proposal" do
    it "should call the mail function" do
      a = ArticleMailer.send("new")
      a.should_receive(:mail).with(to: 'kundenservice@fairnopoly.de', subject: "Category proposal: foobar" ).and_return true
      a.category_proposal("foobar")
    end
  end
end
