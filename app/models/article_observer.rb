# See http://rails-bestpractices.com/posts/19-use-observer

class ArticleObserver < ActiveRecord::Observer
  observe Article

  def after_save(article)
     # Send a Category Proposal
     if article.category_proposal.present?
        ArticleMailer.category_proposal(article.category_proposal).deliver
     end
  end
end
