class ArticleMailer < ActionMailer::Base
  default from: "kundenservice@fairnopoly.de"

  def report_article(article,text)
    @text = text
    @article = article
    mail(:to => "melden@fairnopoly.de", :subject => "Article reported with ID: " + article.id.to_s)
  end

  def category_proposal(category_proposal)
    mail(:to => "kundenservice@fairnopoly.de", :subject => "Category proposal: " + category_proposal)
  end

end