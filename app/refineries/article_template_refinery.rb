class ArticleTemplateRefinery < ApplicationRefinery

  def default
    [
      :name, :article,
      article_attributes: ArticleRefinery.new(Article.new, user).create(false)
    ]
  end
end
